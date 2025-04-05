package main

import nc "../lib/Ncurses/src"

import "editor"
import "row"

import "core:fmt"

main :: proc() {
	e: editor.EDITOR = editor.editor_init()
	defer editor.editor_destroy(&e)

	editor.editor_append_row(&e, nil)

	for {
		editor.editor_refresh_screen(&e)
		editor.editor_process_keypress(&e, nc.getch())
	}
}
