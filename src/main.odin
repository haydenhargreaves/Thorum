package main

import nc "../lib/Ncurses/src"

import "editor"
import "row"

import "core:fmt"

main :: proc() {
	e: editor.EDITOR = editor.editor_init()
	defer editor.editor_destroy(&e)

	str: [dynamic]u8 = make([dynamic]u8, 0, 0)

	// for ch in "Hello, world!" {
	// 	append(&str, u8(ch))
	// }
	//
	// count: int = 10
	//
	// for _ in 0 ..< count {
	// 	copy := make([dynamic]u8, len(str), cap(str))
	// 	for b, i in str {
	// 		copy[i] = b
	// 	}
	//
	// 	editor.editor_append_row(&e, copy)
	// }
	//
	// for i in 0 ..< len(e.rows) {
	// 	editor.editor_draw_row(&e, &e.rows[i], i)
	// }

	editor.editor_append_row(&e, nil)

	nc.move(0, 0)

	for {

		// NOTE: NEED THIS FOR SOME REASON
		ch := nc.getch()

		switch ch {

		case nc.KEY_RIGHT:
			editor.editor_move_cursor(&e, 1, 0)
		case nc.KEY_LEFT:
			editor.editor_move_cursor(&e, -1, 0)
		case nc.KEY_UP:
			editor.editor_move_cursor(&e, 0, -1)
		case nc.KEY_DOWN:
			editor.editor_move_cursor(&e, 0, 1)
		case nc.KEY_BACKSPACE:
			row.row_remove_char(&e.rows[e.cur_y], int(e.cur_x - 1))
			editor.editor_move_cursor(&e, -1, 0)
		case nc.KEY_ENTER:
		case '\n':
			editor.editor_append_row(&e, nil)
			editor.editor_move_cursor(&e, 0, 1)
		case:
			row.row_insert_char(&e.rows[e.cur_y], int(e.cur_x), u8(ch))
			editor.editor_move_cursor(&e, 1, 0)
		}

		// REFRESH
		nc.mvwprintw(
			e.win,
			20,
			0,
			"%d:%d %d %s",
			e.cur_x,
			e.cur_y,
			len(e.rows[e.cur_y].chars),
			e.rows[e.cur_y].chars,
		)

		// MOVE CURSOR
		nc.move(e.cur_y, e.cur_x)

		// WAIT FOR INPUT
		nc.wclear(e.win)
		for i in 0 ..< len(e.rows) {
			editor.editor_draw_row(&e, &e.rows[i], i)
		}

		// REFRESH AGAIN
		nc.move(e.cur_y, e.cur_x)

	}
}
