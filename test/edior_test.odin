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

	e.rows[0].chars = make([dynamic]u8, 0, 0)
	append(&e.rows[0].chars, 'h', 'e', 'l', 'l', 'o')
	testing.expect_value(t, len(e.rows[0].chars), 5)

	editor_destroy(&e)

	testing.expect_value(t, len(e.rows), 0)
}
