/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

new_point :: proc(x, y: f32) -> Point {
	return {x, y}
}

pixel_to_hex_fractional :: proc(layout: Layout, p: Point) -> Hex {
	M := layout.orientation
	origin := layout.origin
	size := layout.size

	pt := new_point((p.x - origin.x) / size.x, (p.y - origin.y) / size.y)

	q := M.b[0, 0] * pt.x + M.b[0, 1] * pt.y
	r := M.b[1, 0] * pt.x + M.b[1, 1] * pt.y

	return new_hex(q, r, -q - r)
}

pixel_to_hex_rounded :: proc(layout: Layout, p: Point) -> Hex {
	return hex_round(pixel_to_hex_fractional(layout, p))
}
