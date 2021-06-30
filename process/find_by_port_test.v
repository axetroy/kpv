module process

import os
import time
import strconv
import net.http

fn get_executable_path(bin_name string, fallback_bin_name string) ?string {
	$if windows {
		return bin_name
	}

	bin_path := os.find_abs_path_of_executable(bin_name) or {
		if fallback_bin_name.len > 0 {
			return get_executable_path(fallback_bin_name, '')
		}

		msg := err.str()

		return error('$msg\nfail find executable $bin_name')
	}

	return bin_path
}

fn start_server(port string) ?int {
	cwd := os.getwd()

	python_path := get_executable_path('python3', 'python') or { return err }

	mut ps := os.new_process(python_path)
	py_file_path := os.join_path(cwd, 'process', 'test_data', 'server.py')
	ps.set_args([py_file_path, port])
	ps.wait()

	if ps.code != 9 && ps.code != 15 {
		return error('process exit with code $ps.code')
	}

	return ps.pid
}

fn test_find_process_by_port() {
	port := 9999

	go start_server('$port')

	time.sleep(time.second * 5)

	resp := http.get('http://localhost:$port') or {
		println('should not dial tcp error')
		panic(err)
	}

	pid_str := resp.header.get_custom('x-pid') or { panic('can not get pid from response') }

	pid := strconv.atoi(pid_str) or { panic(err) }

	ps := find_process_by_port(port) or { panic(err) }

	assert pid > 0
	assert resp.status_code == 200
	assert resp.text == 'Hello world'
	assert ps.pid == pid

	kill(pid, true) or { panic(err) }

	time.sleep(time.second * 2)

	// should throw error
	resp2 := http.get('http://localhost:$port') or {
		// should to into this block
		assert true

		// time.sleep(time.second * 5)

		// find_process_by_port(port) or {
		// 	assert true
		// 	return
		// }

		// // should be go into here
		// assert false

		return
	}

	assert false
}
