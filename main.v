module main

import os

fn parse_columns(text string) []string {
	arr := text.split_nth('', 0)
	mut columns := []string{}
	mut index := 0

	for {
		if index == arr.len {
			break
		}

		current := arr[index].trim_space()

		if current == '' {
			index++
		} else {
			mut char := ''

			charLoop: for {
				if index == arr.len {
					break charLoop
				}

				mut next := arr[index].trim_space()

				if next != '' {
					char += next
					index++
					continue charLoop
				} else {
					index++
					columns << char
					break charLoop
				}
			}
		}
	}

	return columns
}

fn extract_columns(text string, indexs []int, max int) []string {
	mut columns := parse_columns(text)

	mut list := []string{cap: columns.len}

	for index, column in columns {
		for i in indexs {
			if i == index {
				list << column
			}
		}
	}

	return list
}

struct Process {
	proto string
	addr  string
	pid   int
}

fn windows(port int) []Process {
	mut process_list := []Process{}

	bin_name := 'netstat'

	bin_path := os.find_abs_path_of_executable(bin_name) or {
		panic("Can not found executable file '$bin_name' in your \$PATH.\n$err")
	}
	mut ps := os.new_process(bin_path)
	ps.set_args(['-ano'])
	ps.set_redirect_stdio()
	ps.wait()

	output := ps.stdout_slurp().trim_space()

	assert ps.pid > 0
	assert ps.pid != os.getpid()

	lines := output.split_into_lines()

	for index, line in lines {
		if index < 4 {
			continue
		}

		list := extract_columns(line, [1, 4], 5)
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
				info := Process{
					proto: proto
					addr: addr
					pid: pid.int()
				}

				process_list << info
			}
		}
	}

	return process_list
}

fn unix(port int) []Process {
	mut process_list := []Process{}

	bin_name := 'netstat'

	bin_path := os.find_abs_path_of_executable(bin_name) or {
		panic("Can not found executable file '$bin_name' in your \$PATH.\n$err")
	}
	mut ps := os.new_process(bin_path)
	ps.set_args(['-anv', '-anv', '-p', 'TCP'])
	ps.set_redirect_stdio()
	ps.wait()

	output := ps.stdout_slurp().trim_space()

	assert ps.pid > 0
	assert ps.pid != os.getpid()

	lines := output.split_into_lines()

	for index, line in lines {
		if index < 2 {
			continue
		}

		list := extract_columns(line, [0, 3, 8], 11)
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
				info := Process{
					proto: proto
					addr: addr
					pid: pid.int()
				}

				process_list << info
			}
		}
	}

	return process_list
}

fn main() {
	port := 4507
	mut list := []Process{}

	$if windows {
		list = windows(port)
	} $else {
		list = unix(port)
	}

	println(list)
}
