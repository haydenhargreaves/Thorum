package odin

import "../src/editor"
import "core:testing"


@(test)
test :: proc(t: ^testing.T) {
	x: i64 : 1
	y: i64

	y += x

	testing.expect(t, y == x, "Addition failed...")
}

@(test)
test_editor_init :: proc(t: ^testing.T) {
	e := editor.init_editor()
	defer editor.cleanup_editor(&e)

	testing.expect(t, e.cur_x == 0 && e.cur_y == 0, "Failed to init cursor position to (0, 0)")
	testing.expect(t, e.screen != nil, "Failed to init screen")
	testing.expect(t, e.screen_size != nil, "Failed to init screen size")
	testing.expect(t, e.num_rows == 0, "Editor should init with 0 rows")
}
