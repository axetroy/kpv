module main

import os
import process
import strconv

const version = '0.1.0'

fn print_help() {
	print('kpv - Kill the process listening on the specified port
USAGE:
  kpv <OPTIONS> <...PORTS>
OPTIONS:
	-f,--force         kill process with force
EXAMPLE:
  kpv 1080 9527
  kpv -f 1080
VERSION:
	v$version
SOURCE CODE:
  https://github.com/axetroy/kpv
')
}

fn includes<T>(arr []T, target T) bool {
	for el in arr {
		if el == target {
			return true
		}
	}

	return false
}

fn filter_flag(arr []string) []string {
	mut new_arr := []string{}

	for str in arr {
		if !str.starts_with('-') {
			new_arr << str
		}
	}

	return new_arr
}

fn main() {
	mut args := os.args[1..]

	if args.len == 0 || includes(args, '--help') || includes(args, '-h') {
		print_help()
		exit(1)
	}

	if args.len == 0 || includes(args, '--version') || includes(args, '-V') {
		println('v$version')
		exit(1)
	}

	args = filter_flag(args)

	if args.len == 0 {
		println('missing specified port')
		exit(1)
	}

	for arg in args {
		port := strconv.atoi(arg) or {
			println("port must be a number but got '$arg'")
			exit(1)
		}

		assert port > 0

		ps := process.find_process_by_port(port) or {
			println(err)
			continue
		}

		process.kill(ps.pid, true) or {
			println("kill process '$port' fail: '$err'")
			continue
		}

		println("kill port '$port' success in process '$ps.pid'")
	}
}
