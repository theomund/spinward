/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import rl "vendor:raylib"

Point :: struct {
	x, y: f64,
}

new_point :: proc(x, y: f64) -> Point {
	return {x, y}
}

point_to_vector :: proc(p: Point) -> rl.Vector2 {
	return {f32(p.x), f32(p.y)}
}

pixel_to_hex_fractional :: proc(layout: Layout, p: Point) -> Hex(f64) {
	M := layout.orientation
	origin := layout.origin
	size := layout.size

	pt := new_point((p.x - origin.x) / size.x, (p.y - origin.y) / size.y)

	q := M.b0 * pt.x + M.b1 * pt.y
	r := M.b2 * pt.x + M.b3 * pt.y

	return new_hex(q, r, -q - r)
}

pixel_to_hex_rounded :: proc(layout: Layout, p: Point) -> Hex(int) {
	return hex_round(pixel_to_hex_fractional(layout, p))
}
