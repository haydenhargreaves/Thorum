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
