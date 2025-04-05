package main

import nc "../lib/Ncurses/src"

import "editor"
import "row"

import "core:fmt"

main :: proc() {
	e: editor.EDITOR = editor.editor_init()
	defer editor.editor_destroy(&e)
}
