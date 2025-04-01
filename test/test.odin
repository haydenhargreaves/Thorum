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
