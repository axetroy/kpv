module util

import os
import json

fn test_parse_single_column() {
	cwd := os.getwd()

	mut tester := map{
		'darwin_row_1.out':  map{
			'col_num':            '12'
			'may_null_col_index': '-1'
			'json':               'darwin_row_1.out.json'
		}
		'windows_row_1.out': map{
			'col_num':            '5'
			'may_null_col_index': '3'
			'json':               'windows_row_1.out.json'
		}
		'linux_row_1.out':   map{
			'col_num':            '7'
			'may_null_col_index': '5'
			'json':               'linux_row_1.out.json'
		}
		'linux_row_2.out':   map{
			'col_num':            '7'
			'may_null_col_index': '5'
			'json':               'linux_row_2.out.json'
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

		expect_column := json.decode([]string, output_text) or {
			assert err.str() == ''
			break
		}

		col_num := expect['col_num'] or { panic('key not found') }
		may_null_col_index := expect['may_null_col_index'] or { panic('key not found') }

		column := parse_single_column(txt, col_num.int(), may_null_col_index.int())

		assert expect_column == column
	}
}

fn test_parse_table() {
	cwd := os.getwd()

	mut tester := map{
		'darwin_full.out':         map{
			'header_start':       'Proto'
			'col_num':            '12'
			'may_null_col_index': '-1'
			'json':               'darwin_full.out.json'
		}
		'linux_full_not_root.out': map{
			'header_start':       'Proto'
			'col_num':            '7'
			'may_null_col_index': '5'
			'json':               'linux_full_not_root.out.json'
		}
		'linux_full_root.out':     map{
			'header_start':       'Proto'
			'col_num':            '7'
			'may_null_col_index': '5'
			'json':               'linux_full_root.out.json'
		}
		'windows_full.out':        map{
			'header_start':       'Proto'
			'col_num':            '5'
			'may_null_col_index': '3'
			'json':               'windows_full.out.json'
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

		header_start := expect['header_start'] or { panic('key not found') }
		col_num := expect['col_num'] or { panic('key not found') }
		may_null_col_index := expect['may_null_col_index'] or { panic('key not found') }

		arr := parse_table(txt, header_start.str(), col_num.int(), may_null_col_index.int())

		assert expect_columns == arr
	}
}
