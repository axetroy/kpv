module util

/**
 * 解析表格
*/
pub fn parse_table(table_txt string, table_header_line int) [][]string {
	lines := table_txt.split_into_lines()

	mut columns := [][]string{}

	for index, line in lines {
		if index < table_header_line {
			continue
		}

		column := parse_single_column(line)

		columns << column
	}

	return columns
}

/**
 * 解析输出的表格
*/
pub fn parse_single_column(text string) []string {
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
					if char.len != 0 {
						columns << char
					}
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
