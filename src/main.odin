package main

import window "window"

main :: proc() {
	win: window.WINDOW = window.window_init()
	defer window.window_destory(&win)

	for {

	}
}
