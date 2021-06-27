module util

import os
import json

fn test_parse_single_column() {
	cwd := os.getwd()

	mut tester := map{
		'darwin_row.out':  ['tcp4', '0', '0', '127.0.0.1.1080', '127.0.0.1.55808', 'ESTABLISHED',
			'407486', '146988', '28025', '0', '0x0102', '0x0000002c']
		'windows_row.out': ['TCP', '127.0.0.1:16308', '127.0.0.1:64234', 'ESTABLISHED', '4392']
		'linux_row.out':   ['tcp6', '0', '0', ':::9527', ':::*', 'LISTEN', '96140/./yhz-builder']
		// 'linux_row_2.out':   ['udp6', '0', '0', ':::5353', ':::*', '', '-']
	}

	for file, expected in tester {
		filepath := os.join_path(cwd, 'util', 'test_data', file)

		txt := os.read_file(filepath) or {
			assert err.str() == ''
			break
		}

		column := parse_single_column(txt)

		assert expected == column
	}
}

fn test_parse_table() {
	cwd := os.getwd()

	mut tester := map{
		'darwin_full.out':         map{
			'header_start': 'Proto'
			'json':         'darwin_full.out.json'
		}
		'linux_full_not_root.out': map{
			'header_start': 'Proto'
			'json':         'linux_full_not_root.out.json'
		}
		'linux_full_root.out':     map{
			'header_start': 'Proto'
			'json':         'linux_full_root.out.json'
		}
		'windows_full.out':        map{
			'header_start': 'Proto'
			'json':         'windows_full.out.json'
		}
	}

	for file, expect in tester {
		json_file_name := expect['json'] or { panic('key not found') }

		test_file := os.join_path(cwd, 'util', 'test_data', file)
		output_file := os.join_path(cwd, 'util', 'test_data', json_file_name)

		txt := os.read_file(test_file) or {
			assert err.str() == ''
			break
		}

		output_text := os.read_file(output_file) or {
			assert err.str() == ''
			break
		}

		expect_columns := json.decode([][]string, output_text) or {
			assert err.str() == ''
			break
		}

		header_size := expect['header_start'] or { panic('key not found') }

		arr := parse_table(txt, header_size.str())

		assert expect_columns == arr
	}
}
