package mai

import T "../lib/TermCL"
import "core:fmt"

import "editor"


main :: proc() {
	e := editor.init_editor()
	defer editor.destroy_editor(&e)

	// fmt.println(e.screen)
	// fmt.printfln("%p -> &p", &e, e.screen)
  fmt.printfln("%p", e.screen)
	editor.setup_editor(&e)


	for {
		inp, _ := T.read(e.screen)
		keys, ok := T.parse_keyboard_input(inp)

		if ok {
			if keys.key == .Space {
				T.write(e.screen, " ")
			} else {
				T.writef(e.screen, "%s", keys.key)
			}
		}

		T.blit_screen(e.screen)
	}
}

// e :: proc() {
// 	using T
// 	editor: Editor = Editor{}
//
// 	screen := init_screen()
// 	defer {
// 		set_term_mode(&screen, .Restored)
// 		destroy_screen(&screen)
// 	}
//
// 	size := get_term_size(&screen)
//
// 	editor.screen = screen
// 	editor.screen_size = size
//
// 	set_term_mode(&screen, .Cbreak)
// 	clear_screen(&screen, .Everything)
// 	move_cursor(&screen, 0, 0)
// 	blit_screen(&screen)
//
//
// 	for {
// 		inp, _ := read(&screen)
//
// 		keys, ok := parse_keyboard_input(inp)
//
// 		if ok {
// 			#partial switch keys.key {
// 			case .Space:
// 				write(&screen, " ")
// 			case .A ..= .Z:
// 				writef(&screen, "%s", keys.key)
// 			}
// 		}
//
//
// 		blit_screen(&screen)
// 		// move_cursor(&screen, editor.cur_y, editor.cur_x)
// 	}
// }
