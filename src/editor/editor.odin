package editor

import nc "../../lib/Ncurses/src"
import _row "../row/"

import "core:fmt"

EDITOR :: struct {
	version: f32,
	rows:    [dynamic]_row.ROW,
	win:     nc.Window,
	cur_x:   i32,
	cur_y:   i32,
}

EDITOR_ERROR :: enum {
	none,
	out_of_bounds,
	missing_window,
	invalid_row,
}

editor_init :: proc() -> EDITOR {
	using nc
	win := initscr()
	cbreak()
	noecho()
	keypad(win, true)

	// Color settings
	start_color()
	assume_default_colors(COLOR_WHITE, COLOR_BLACK)
	use_default_colors()

	editor: EDITOR = EDITOR {
		version = 0.1,
		rows    = make([dynamic]_row.ROW, 0, 0),
		win     = win^,
		cur_x   = 0,
		cur_y   = 0,
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

	nc.endwin()
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
	if len(e.rows) <= pos || pos < 0 {
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
	if len(e.rows) <= pos || pos < 0 {
		return .out_of_bounds
	}

	delete(e.rows[pos].chars)
	unordered_remove(&e.rows, pos)

	return .none
}

editor_draw_row :: proc(e: ^EDITOR, row: ^_row.ROW, pos: int) -> EDITOR_ERROR {
	if row == nil {
		return .invalid_row
	}

	if pos >= len(e.rows) || pos < 0 {
		return .out_of_bounds
	}

	nc.mvwprintw(&e.win, i32(pos), 0, "%s", row.chars)

	return .none
}

// NOTE: This procedure does not MOVE the cursor, refresh will handle that
editor_move_cursor :: proc(e: ^EDITOR, x: i32, y: i32) {
	e.cur_x += x
	e.cur_y += y

	if e.cur_y < 0 {
		e.cur_y = 0
	}

	// Check if there are any rows, if no rows, cursor doesn't move
	if e.cur_y >= i32(len(e.rows)) {
		if len(e.rows) > 0 {
			e.cur_y = i32(len(e.rows)) - 1
		} else {
			e.cur_y = 0 // If no rows, cursor stays at 0
		}
	}

	// Clamp horizontal movement based on the current row
	if len(e.rows) > 0 {
		current_row := e.rows[e.cur_y]
		// If the current row is nil or empty, cursor goes to 0
		if current_row.chars == nil || len(current_row.chars) == 0 {
			e.cur_x = 0
		} else if e.cur_x < 0 {
			e.cur_x = 0
		} else if e.cur_x > i32(len(current_row.chars)) {
			e.cur_x = i32(len(current_row.chars))
		}
	} else {
		e.cur_x = 0 // If no rows, horizontal cursor is also 0
	}
}

editor_refresh_screen :: proc(e: ^EDITOR) {

}
