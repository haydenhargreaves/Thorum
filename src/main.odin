package main

import nc "../lib/Ncurses/src"
import "core:fmt"
import "core:strings"

main :: proc() {
	win := nc.initscr()
	nc.start_color()
	nc.cbreak()
	nc.noecho()
	nc.keypad(win, true)

	defer nc.endwin()

	nc.init_pair(1, nc.COLOR_RED, nc.COLOR_BLUE)
	nc.init_pair(2, nc.COLOR_RED, nc.COLOR_BLUE)

	builder: strings.Builder
	strings.builder_init(&builder)
	defer strings.builder_destroy(&builder)

	for {
		nc.attron(nc.COLOR_PAIR(1))
		char := nc.getch()

		strings.write_rune(&builder, rune(char))

		nc.mvwprintw(win, 0, 0, "%s", strings.to_string(builder))
	}


}
