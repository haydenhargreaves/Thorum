package main

import nc "../lib/Ncurses/src"

import "editor"
import "row"
import "window"

import "core:fmt"

main :: proc() {
	win: window.WINDOW = window.window_init()
	defer window.window_destory(&win)

	e: editor.EDITOR = editor.editor_init(&win)
	defer editor.editor_destroy(&e)

	str: [dynamic]u8 = make([dynamic]u8, 0, 0)

	for ch in "Hello, world!" {
		append(&str, u8(ch))
	}

	editor.editor_append_row(&e, str)
	editor.editor_append_row(&e, str)
	editor.editor_append_row(&e, str)
	editor.editor_append_row(&e, str)
	editor.editor_append_row(&e, str)
	editor.editor_draw_row(&e, &e.rows[0], 0)
	editor.editor_draw_row(&e, &e.rows[1], 1)
	editor.editor_draw_row(&e, &e.rows[2], 2)
	editor.editor_draw_row(&e, &e.rows[3], 3)
	editor.editor_draw_row(&e, &e.rows[4], 4)

	for {
		// NOTE: NEED THIS FOR SOME REASON
		nc.getch()
	}
}
