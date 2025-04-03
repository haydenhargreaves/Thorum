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


	count: int = 10

	for _ in 0 ..< count {
		editor.editor_append_row(&e, str)
	}

	for {
		// NOTE: NEED THIS FOR SOME REASON
		for i in 0 ..< len(e.rows) {
			editor.editor_draw_row(&e, &e.rows[i], i)
		}

		// REFRESH

		// MOVE CURSOR

		// WAIT FOR INPUT

		// REFRESH AGAIN

		nc.getch()
	}
}
