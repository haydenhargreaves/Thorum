package window

import nc "../../lib/Ncurses/src"

WINDOW :: struct {
	window: ^nc.Window,
	height: i32,
	width:  i32,
}


window_init :: proc() -> WINDOW {
	using nc
	w := WINDOW {
		window = initscr(),
		width  = COLS,
		height = LINES,
	}

	start_color()
	cbreak()
	noecho()
	keypad(w.window, true)

	assume_default_colors(COLOR_WHITE, COLOR_BLACK)
	use_default_colors()

	return w
}

// NOTE: Window param isn't 
window_destory :: proc(win: ^WINDOW) {
	using nc
	endwin()
}
