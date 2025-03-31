package editor

import T "../../lib/TermCL"
import "core:fmt"
import "core:strings"

Editor :: struct {
	num_rows: int,
	cur_x:    uint,
	cur_y:    uint,
	screen:   ^T.Screen,
}

init_editor :: proc() -> Editor {
	using T
	scn := init_screen()
	set_term_mode(&scn, .Cbreak)

	e: Editor = Editor {
		screen = &scn,
	}

	return e
}

setup_editor :: proc(e: ^Editor) {
	using T

	fmt.printfln("%p", e.screen)

	if e.screen == nil {
		fmt.println("Fuck me sideways")
		return
	}

	pos, ok := get_cursor_position(e.screen)
	if ok {
		fmt.println(pos)
	}

	clear_screen(e.screen, .Everything)
	blit_screen(e.screen)
}


destroy_editor :: proc(e: ^Editor) {
	// TODO: We might need this, but for now not yet
	//       This is to prevent the stupid screw up 
	//       on kill.

	// T.set_term_mode(e.screen, .Restored)
	strings.builder_destroy(&e.screen.seq_builder)
}
