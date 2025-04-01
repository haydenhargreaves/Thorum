package editor

import row "../row/"

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
editor_destroy :: proc(e: ^EDITOR) {
	for row in e.rows {
		delete(row.chars)
	}

	delete(e.rows)
}
