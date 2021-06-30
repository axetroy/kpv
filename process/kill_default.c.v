module process

import os

pub fn kill(pid int, force bool) ? {
	bin_name := 'kill'

	bin_path := os.find_abs_path_of_executable(bin_name) or {
		return error(err_command_not_found.str() + ' $bin_name')
	}
	mut ps := os.new_process(bin_path)
	mut argv := []string{}
	if force {
		argv << '-9'
	} else {
		argv << '-15'
	}
	argv << '$pid'
	ps.set_args(argv)
	ps.wait()

	if ps.code != 0 {
		return error('kill process $pid fail.')
	}

	return
}
