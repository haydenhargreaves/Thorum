package row

import nc "../../lib/Ncurses/src"
import "core:fmt"


// NOTE: Anywhere these are used, we need to delete `chars`
ROW :: struct {
	chars: [dynamic]u8,
}

// TODO: Should I include a none value?
ROW_ERROR :: enum {
	allocation_failed,
	out_of_bounds,
}


row_insert_char :: proc(row: ^ROW, pos: int, char: u8) -> ROW_ERROR {
	if len(row^.chars) < pos || pos < 0 {
		return .out_of_bounds
	}

	ok, _ := inject_at(&row^.chars, pos, char)
	if !ok {
		return .allocation_failed
	}
	return nil
}


row_remove_char :: proc(row: ^ROW, pos: int) -> ROW_ERROR {
	if len(row^.chars) < pos || pos < 0 {
		return .out_of_bounds
	}

	ordered_remove(&row^.chars, pos)
	return nil
}
