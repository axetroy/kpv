module main

import os
import process

fn print_help() {
	print('kpv - Kill the process listening on the specified port
USAGE:
  kpv <port>
EXAMPLE:
  kpv 1080
SOURCE CODE:
  https://github.com/axetroy/kpv
')
}

fn main() {
	args := os.args[1..]
	if args.len == 0 {
		print_help()
		exit(1)
	}

	for arg in args {
		port := arg.int()

		assert port > 0

		ps := process.find_process_by_port(port) or {
			println(err)
			break
		}

		process.kill(ps.pid) or {
			println("kill process '$port' fail: '$err'")
			break
		}

		println("kill port '$port' success in process '$ps.pid'")
	}
}
