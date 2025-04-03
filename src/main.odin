package main

import "editor"
import "row"
import "window"

main :: proc() {
	win: window.WINDOW = window.window_init()
	defer window.window_destory(&win)

	e: editor.EDITOR = editor.editor_init()
	defer editor.editor_destroy(&e)

	str: [dynamic]u8 = make([dynamic]u8, 0, 0)
	for ch in "Hello, world!" {
		append(&str, u8(ch))
	}
	editor.editor_append_row(&e, str)

	for {

	}
}
