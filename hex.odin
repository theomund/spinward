/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

HEX_SIZE :: 64

Hex :: rl.Vector3

new_hex :: proc(q, r, s: f32) -> Hex {
	assert(math.round(q + r + s) == 0)

	return {q, r, s}
}

hex_index :: proc(hex: Hex) -> cstring {
	offset := qoffset_from_cube(hex)

	x := i32(offset.x + 1)
	y := i32(offset.y + 1)

	return fmt.caprintf("%02d%02d", x, y)
}

hex_lerp :: proc(a, b: Hex, t: f32) -> Hex {
	return math.lerp(a, b, t)
}

hex_to_pixel :: proc(layout: Layout, hex: Hex) -> Point {
	M := layout.orientation
	size := layout.size
	origin := layout.origin

	x := (M.f[0, 0] * hex.x + M.f[0, 1] * hex.y) * size.x
	y := (M.f[1, 0] * hex.x + M.f[1, 1] * hex.y) * size.y

	return new_point(x + origin.x, y + origin.y)
}

hex_round :: proc(hex: Hex) -> Hex {
	q := math.round(hex.x)
	r := math.round(hex.y)
	s := math.round(hex.z)

	q_diff := math.abs(q - hex.x)
	r_diff := math.abs(r - hex.y)
	s_diff := math.abs(s - hex.z)

	if q_diff > r_diff && q_diff > s_diff {
		q = -r - s
	} else if r_diff > s_diff {
		r = -q - s
	} else {
		s = -q - r
	}

	return new_hex(q, r, s)
}

draw_hex :: proc(layout: Layout, hex: Hex, color: rl.Color, fill := false) {
	center := hex_to_pixel(layout, hex)

	if fill {
		rl.DrawPoly(center, 6, HEX_SIZE, 0, color)
	} else {
		rl.DrawPolyLines(center, 6, HEX_SIZE, 0, color)
	}
}
