/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

Point :: rl.Vector2

grid_center :: proc(layout: Layout, width, height: f32) -> (center: Point, err: Error) {
	a := qoffset_to_cube({0, 0}) or_return
	b := qoffset_to_cube({width - 1, height - 1}) or_return

	return hex_to_pixel(layout, (a + b) / 2), nil
}

pixel_to_hex_fractional :: proc(layout: Layout, p: Point) -> (Hex, Error) {
	M := layout.orientation
	origin := layout.origin

	pt := Point{(p.x - origin.x) / HEX_SIZE, (p.y - origin.y) / HEX_SIZE}

	q := M.b[0, 0] * pt.x + M.b[0, 1] * pt.y
	r := M.b[1, 0] * pt.x + M.b[1, 1] * pt.y

	return new_hex(q, r, -q - r)
}

pixel_to_hex_rounded :: proc(layout: Layout, p: Point) -> (rounded: Hex, err: Error) {
	fractional := pixel_to_hex_fractional(layout, p) or_return

	return hex_round(fractional)
}
