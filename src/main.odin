package main

import nc "../lib/Ncurses/src"
import "core:fmt"

main :: proc() {
	win := nc.initscr()
	nc.start_color()
	nc.cbreak()
	nc.noecho()
	nc.keypad(win, true)

	defer nc.endwin()


	nc.assume_default_colors(nc.COLOR_WHITE, nc.COLOR_BLACK)
	nc.use_default_colors()

	for {
		char := nc.getch()
		fmt.printf("%c", char)
	}

}
