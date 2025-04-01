package odin

import row "../src/row/"
import "core:testing"

@(test)
test_row_insert_char :: proc(t: ^testing.T) {
	using row

	r: ROW
	defer delete(r.chars)

	{
		err := row_insert_char(&r, 0, 'h')
		testing.expect_value(t, r.chars[0], 'h')
		testing.expect_value(t, err, nil)
	}

	{
		err := row_insert_char(&r, 10, 'h')
		testing.expect_value(t, err, ROW_ERROR.out_of_bounds)
	}
}

@(test)
test_row_remove_char :: proc(t: ^testing.T) {
	using row

	r: ROW
	defer delete(r.chars)
	append(&r.chars, 'a', 'b', 'c', 'd', 'e')

	{
		err := row_remove_char(&r, 0)
		testing.expect_value(t, r.chars[0], 'b')
		testing.expect_value(t, len(r.chars), 4)
		testing.expect_value(t, err, nil)
	}

	{
		err := row_remove_char(&r, 10)
		testing.expect_value(t, r.chars[0], 'b')
		testing.expect_value(t, len(r.chars), 4)
		testing.expect_value(t, err, ROW_ERROR.out_of_bounds)
	}
}
