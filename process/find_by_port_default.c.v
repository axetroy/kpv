module process

import os
import util

const (
	err_not_found = error('The port is available:')
)

fn find_process_by_port_from_protocol(port int, protocol string) ?&Process {
	mut process_list := []&Process{}

	bin_name := 'netstat'

	bin_path := os.find_abs_path_of_executable(bin_name) or { return err }
	mut ps := os.new_process(bin_path)
	ps.set_args(['-anv', '-p', protocol])
	ps.set_redirect_stdio()
	ps.wait()

	output := ps.stdout_slurp().trim_space()

	assert ps.code == 0

	table_header_line := 2
	proto_index := 0
	addr_index := 3
	pid_index := 8

	columns := util.parse_table(output, table_header_line)

	for column in columns {
		proto := column[proto_index].str()
		addr := column[addr_index].str()
		pid := column[pid_index].str()

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
		msg := process.err_not_found.str()
		return error('$msg $port')
	}

	return process_list[0]
}

pub fn find_process_by_port(port int) ?&Process {
	mut ps := find_process_by_port_from_protocol(port, 'tcp') or {
		if err.str().starts_with(process.err_not_found.str()) {
			return find_process_by_port_from_protocol(port, 'udp')
		}

		return err
	}

	return ps
}
