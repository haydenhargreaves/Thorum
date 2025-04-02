package odin

import editor "../src/editor/"
import row "../src/row"
import "core:testing"

@(test)
test_editor_init :: proc(t: ^testing.T) {
	using editor

	e: EDITOR = editor_init()
	defer delete(e.rows)

	testing.expect_value(t, e.version, 0.1)
	testing.expect_value(t, len(e.rows), 0)
	testing.expect_value(t, cap(e.rows), 0)

}

@(test)
test_editor_destroy :: proc(t: ^testing.T) {
	using editor

	e: EDITOR = editor_init()

	append(&e.rows, row.ROW{})
	testing.expect_value(t, len(e.rows), 1)

	editor_destroy(&e)
	testing.expect_value(t, len(e.rows), 0)
}

@(test)
test_editor_append_row :: proc(t: ^testing.T) {
	using editor

	e: EDITOR = editor_init()
	defer editor_destroy(&e)

	testing.expect_value(t, len(e.rows), 0)

	{
		// We don't need to free, since destroy will 
		// free the memory for us
		arr: [dynamic]u8 = make([dynamic]u8, 0, 0)

		for c in "Hello world!" {
			append(&arr, u8(c))
		}

		editor_append_row(&e, arr)
		testing.expect_value(t, len(e.rows), 1)
		testing.expect_value(t, len(e.rows[0].chars), 12)
	}

	{
		editor_append_row(&e, nil)
		testing.expect_value(t, len(e.rows), 2)
		testing.expect_value(t, len(e.rows[1].chars), 0)

		// Make sure we can still append even when set to nil
		row.row_insert_char(&e.rows[1], 0, 'a')
		testing.expect_value(t, len(e.rows[1].chars), 1)
	}
}

@(test)
test_editor_insert_row :: proc(t: ^testing.T) {
	using editor

	e: EDITOR = editor_init()
	defer editor_destroy(&e)

	append(&e.rows, row.ROW{})
	append(&e.rows, row.ROW{})
	append(&e.rows, row.ROW{})
	append(&e.rows, row.ROW{})
	append(&e.rows, row.ROW{})
	testing.expect_value(t, len(e.rows), 5)

	{
		err := editor_insert_row(&e, 2, nil)
		testing.expect_value(t, err, nil)
		testing.expect_value(t, len(e.rows), 6)
		testing.expect_value(t, len(e.rows[2].chars), 0)
	}

	{
		arr: [dynamic]u8 = make([dynamic]u8, 0, 0)

		for c in "Hello world!" {
			append(&arr, u8(c))
		}

		err := editor_insert_row(&e, 0, arr)
		testing.expect_value(t, err, nil)
		testing.expect_value(t, len(e.rows), 7)
		testing.expect_value(t, len(e.rows[0].chars), 12)
	}

	{
		err := editor_insert_row(&e, 7, nil)
		testing.expect_value(t, err, EDITOR_ERROR.out_of_bounds)
		testing.expect_value(t, len(e.rows), 7)
		testing.expect_value(t, len(e.rows[0].chars), 12)
	}

	{
		err := editor_insert_row(&e, 10, nil)
		testing.expect_value(t, err, EDITOR_ERROR.out_of_bounds)
		testing.expect_value(t, len(e.rows), 7)
	}

	{
		err := editor_insert_row(&e, -1, nil)
		testing.expect_value(t, err, EDITOR_ERROR.out_of_bounds)
		testing.expect_value(t, len(e.rows), 7)
	}
}
