package window

import nc "../../lib/Ncurses/src"

WINDOW :: struct {
	win:    ^nc.Window,
	height: i32,
	width:  i32,
}


window_init :: proc() -> WINDOW {
	using nc
	w := WINDOW {
		win    = initscr(),
		width  = COLS,
		height = LINES,
	}

	start_color()
	cbreak()
	noecho()
	keypad(w.win, true)

	return w
}

// NOTE: Window param isn't 
window_destory :: proc(win: ^WINDOW) -> i32 {
	using nc
	return endwin()
}
