package odin

import nc "../lib/Ncurses/src"
import window "../src/window"
import "core:testing"

@(test)
test_window_init :: proc(t: ^testing.T) {
	using window

	win: WINDOW = window_init()
	defer nc.endwin()

	testing.expect_value(t, typeid_of(type_of(win)), typeid_of(type_of(WINDOW{})))
}

@(test)
test_window_destroy :: proc(t: ^testing.T) {
	using window

	win: WINDOW = window_init()
	testing.expect_value(t, typeid_of(type_of(win)), typeid_of(type_of(WINDOW{})))

	// TODO: This doesn't actually do anything
	window_destory(&win)
}
