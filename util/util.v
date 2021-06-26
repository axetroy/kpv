module util

/**
 * 解析输出的表格
*/
pub fn parse_columns(text string) []string {
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

/**
 * 解析表格，然后从表格中提取数据
*/
pub fn extract_columns(text string, indexs []int, max int) []string {
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
