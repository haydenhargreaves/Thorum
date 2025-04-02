package editor

import row "../row/"
import "core:fmt"

EDITOR :: struct {
	version: f32,
	rows:    [dynamic]row.ROW,
}

editor_init :: proc() -> EDITOR {
	editor: EDITOR = EDITOR {
		version = 0.1,
		rows    = make([dynamic]row.ROW, 0, 0),
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
