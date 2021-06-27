module util

/**
 * 解析表格
*/
pub fn parse_table(table_txt string, header_first_col string, col_num int, may_null_col_index int) [][]string {
	lines := table_txt.split_into_lines()

	mut columns := [][]string{}

	mut header_line_index := 0

	for index, raw in lines {
		line := raw.trim_space()

		if line.starts_with(header_first_col) {
			header_line_index = index
			continue
		}

		if header_line_index == 0 {
			continue
		}

		column := parse_single_column(line, col_num, may_null_col_index)

		columns << column
	}

	return columns
}

/**
 * 解析输出的表格
*/
fn parse_single_column(line string, col_num int, may_null_col_index int) []string {
	arr := line.split_nth('', 0)
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
					break charLoop
				}
			}

			columns << char
		}
	}

	if columns.len < col_num {
		columns.insert(may_null_col_index, '')
	}

	return columns
}
