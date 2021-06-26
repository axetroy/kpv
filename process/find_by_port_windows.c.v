module process

import os
import util

pub fn find_process_by_port(port int) ?&Process {
	mut process_list := []&Process{}

	bin_name := 'netstat'

	bin_path := os.find_abs_path_of_executable(bin_name) or {
		return error("Can not found executable file '$bin_name' in your \$PATH.\n$err")
	}
	mut ps := os.new_process(bin_path)
	ps.set_args(['-ano'])
	ps.set_redirect_stdio()
	ps.wait()

	output := ps.stdout_slurp().trim_space()

	assert ps.code == 0

	lines := output.split_into_lines()
	table_header_line := 4

	for index, line in lines {
		if index < table_header_line {
			continue
		}

		list := util.extract_columns(line, [0, 1, 4], 5)

		assert list.len == 3

		proto := list[0]
		addr := list[1]
		pid := list[2]

		if addr.ends_with('.$port') {
			mut is_exist := false

			for d in process_list {
				if d.pid == pid.int() {
					is_exist = true
					break
				}
			}

			if !is_exist {
				info := &Process{
					proto: proto
					addr: addr
					pid: pid.int()
				}

				process_list << info
			}
		}
	}

	if process_list.len == 0 {
		return error("can not found process with port '$port'")
	}

	return process_list[0]
}
