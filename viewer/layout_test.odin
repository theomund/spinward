package viewer

import "core:testing"

@(test)
test_layout :: proc(t: ^testing.T) {
	h := new_hex(3, 4, -7)
	flat := new_layout(flat_orientation(), new_point(10.0, 15.0), new_point(35.0, 71.0))

	testing.expect_value(t, pixel_to_hex_rounded(flat, hex_to_pixel(flat, h)), h)
}
