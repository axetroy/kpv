module util

import os

fn test_parse_columns() {
	cwd := os.getwd()

	mut tester := map{
		'darwin.out':  ['tcp4', '0', '0', '127.0.0.1.1080', '127.0.0.1.55808', 'ESTABLISHED',
			'407486', '146988', '28025', '0', '0x0102', '0x0000002c']
		'windows.out': ['TCP', '127.0.0.1:16308', '127.0.0.1:64234', 'ESTABLISHED', '4392']
		'linux.out':   ['tcp6', '0', '0', ':::9527', ':::*', 'LISTEN', '96140/./yhz-builder']
	}

	for file, expected in tester {
		filepath := os.join_path(cwd, 'util', 'test_data', file)

		txt := os.read_file(filepath) or {
			assert err.str() == ''
			break
		}

		arr := parse_columns(txt)

		assert expected == arr
	}
}
