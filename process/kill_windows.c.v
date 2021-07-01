module process

import os

pub fn kill(pid int, force bool) ? {
	bin_path := 'taskkill.exe'

	mut ps := os.new_process(bin_path)
	mut argv := []string{}
	if force {
		argv << '/F'
	}
	argv << '/T'
	argv << '/PID'
	argv << '$pid'
	ps.set_args(argv)
	ps.wait()

	return
}
