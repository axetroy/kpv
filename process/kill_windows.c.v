module process

import os

pub fn kill(pid int, force bool) ? {
	bin_name := 'taskkill'

	bin_path := os.find_abs_path_of_executable(bin_name) or {
		return error("Can not found executable file '$bin_name' in your \$PATH.\n$err")
	}
	mut ps := os.new_process(bin_path)
	mut argv := []string{}
	if force {
		argv << '/F'
	}
	argv << '/T'
	argv << '/PID'
	argv << '$pid'
	ps.set_args(argv)
	ps.set_redirect_stdio()
	ps.wait()

	stdout := ps.stdout_slurp().trim_space()
	stderr := ps.stderr_slurp().trim_space()

	if ps.code != 0 {
		return error('$stdout\n$stderr')
	}

	return
}
