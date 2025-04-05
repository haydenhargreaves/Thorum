package odin

import nc "../lib/Ncurses/src"
import editor "../src/editor/"
import row "../src/row"
import "core:testing"

@(test)
test_editor_init :: proc(t: ^testing.T) {
	using editor

	e: EDITOR = editor_init()
	defer delete(e.rows)
	defer nc.endwin()

	testing.expect_value(t, e.version, 0.1)
	testing.expect_value(t, len(e.rows), 0)
	testing.expect_value(t, cap(e.rows), 0)
	testing.expect_value(t, e.cur_x, 0)
	testing.expect_value(t, e.cur_y, 0)
	testing.expect_value(t, &e.win != nil, true)
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
		testing.expect_value(t, err, EDITOR_ERROR.none)
		testing.expect_value(t, len(e.rows), 6)
		testing.expect_value(t, len(e.rows[2].chars), 0)
	}

	{
		arr: [dynamic]u8 = make([dynamic]u8, 0, 0)

		for c in "Hello world!" {
			append(&arr, u8(c))
		}

		err := editor_insert_row(&e, 0, arr)
		testing.expect_value(t, err, EDITOR_ERROR.none)
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

@(test)
test_editor_remove_row :: proc(t: ^testing.T) {
	using editor

	e: EDITOR = editor_init()
	defer editor_destroy(&e)

	append(&e.rows, row.ROW{})
	append(&e.rows, row.ROW{})
	append(&e.rows, row.ROW{chars = make([dynamic]u8, 10, 10)})
	append(&e.rows, row.ROW{})
	append(&e.rows, row.ROW{})
	testing.expect_value(t, len(e.rows[2].chars), 10)
	testing.expect_value(t, len(e.rows), 5)

	{
		err := editor_remove_row(&e, 2)
		testing.expect_value(t, err, EDITOR_ERROR.none)
		testing.expect_value(t, len(e.rows), 4)
		testing.expect_value(t, len(e.rows[2].chars), 0)
	}

	{
		err := editor_remove_row(&e, -1)
		testing.expect_value(t, err, EDITOR_ERROR.out_of_bounds)
		testing.expect_value(t, len(e.rows), 4)
	}

	{
		err := editor_remove_row(&e, 10)
		testing.expect_value(t, err, EDITOR_ERROR.out_of_bounds)
		testing.expect_value(t, len(e.rows), 4)
	}
}

@(test)
test_editor_draw_row :: proc(t: ^testing.T) {
	using editor
	using row

	{
		e: EDITOR = editor_init()
		defer editor_destroy(&e)

		err := editor_draw_row(&e, nil, 0)
		testing.expect_value(t, err, EDITOR_ERROR.invalid_row)

		row: ROW = ROW{}
		{
			err := editor_draw_row(&e, &row, 10)
			testing.expect_value(t, err, EDITOR_ERROR.out_of_bounds)
		}

		{
			err := editor_draw_row(&e, &row, -1)
			testing.expect_value(t, err, EDITOR_ERROR.out_of_bounds)
		}

		{
			arr := make([dynamic]u8, 10, 10)

			editor_append_row(&e, arr)
			testing.expect_value(t, len(e.rows), 1)

			err := editor_draw_row(&e, &row, 0)
			testing.expect_value(t, err, nil)
		}
	}
}

@(test)
test_editor_move_cursor :: proc(t: ^testing.T) {
	using editor

	e: EDITOR = editor_init()
	defer editor_destroy(&e)

	testing.expect_value(t, e.cur_x, 0)
	testing.expect_value(t, e.cur_y, 0)

	{
		editor_move_cursor(&e, 1, 2)
		testing.expect_value(t, e.cur_x, 0)
		testing.expect_value(t, e.cur_y, 0)
	}

	arr: [dynamic]u8 = make([dynamic]u8, 0, 0)
	for ch in "Hello" {
		append(&arr, u8(ch))
	}

	editor_append_row(&e, nil)
	editor_append_row(&e, arr)

	{
		editor_move_cursor(&e, 1, 2)
		testing.expect_value(t, e.cur_x, 1)
		testing.expect_value(t, e.cur_y, 1)
	}

	{
		editor_move_cursor(&e, -1, -1)
		testing.expect_value(t, e.cur_x, 0)
		testing.expect_value(t, e.cur_y, 0)
	}

	{
		editor_move_cursor(&e, -1, -5)
		testing.expect_value(t, e.cur_x, 0)
		testing.expect_value(t, e.cur_y, 0)
	}
}
