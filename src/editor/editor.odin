package editor

import nc "../../lib/Ncurses/src"
import _row "../row/"
import window "../window"

import "core:fmt"

EDITOR :: struct {
	version: f32,
	rows:    [dynamic]_row.ROW,
	win:     ^window.WINDOW,
}

EDITOR_ERROR :: enum {
	none,
	out_of_bounds,
	missing_window,
	invalid_row,
}

editor_init :: proc(win: ^window.WINDOW) -> EDITOR {
	editor: EDITOR = EDITOR {
		version = 0.1,
		rows    = make([dynamic]_row.ROW, 0, 0),
		win     = win,
	}

	return editor
}

// NOTE: For now this also clears and frees the chars, this
// should likely be done in another function.
editor_destroy :: proc(e: ^EDITOR) {
	for row in e^.rows {
		// This creates a copied slice, which points to the same 
		// underlying array. Which is why we need the variable.
		chars := row.chars

		clear(&chars)
		delete(chars)
	}

	clear(&e.rows)
	delete(e.rows)
}

// NOTE: nil can be passed as str to append nothing
editor_append_row :: proc(e: ^EDITOR, str: [dynamic]u8) {
	row := _row.ROW {
		chars = str,
	}

	append(&e.rows, row)
}

// NOTE: nil can be passed as str to append nothing
editor_insert_row :: proc(e: ^EDITOR, pos: int, str: [dynamic]u8) -> EDITOR_ERROR {
	if len(e^.rows) <= pos || pos < 0 {
		return .out_of_bounds
	}

	row := _row.ROW {
		chars = str,
	}

	inject_at(&e^.rows, pos, row)
	return .none
}

// TODO: Should we shrink the lists?
editor_remove_row :: proc(e: ^EDITOR, pos: int) -> EDITOR_ERROR {
	if len(e^.rows) <= pos || pos < 0 {
		return .out_of_bounds
	}

	delete(e^.rows[pos].chars)
	unordered_remove(&e^.rows, pos)

	return .none
}

editor_draw_row :: proc(e: ^EDITOR, row: ^_row.ROW, pos: int) -> EDITOR_ERROR {
	if e^.win == nil {
		return .missing_window
	}

	if row == nil {
		return .invalid_row
	}

	if pos >= len(e^.rows) || pos < 0 {
		return .out_of_bounds
	}

	code := nc.mvwprintw(e^.win.window, i32(pos), 0, "%s", row.chars)

	return .none
}
