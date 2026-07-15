/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Hex :: rl.Vector3

new_hex :: proc(q, r, s: f32) -> Hex {
	assert(math.round(q + r + s) == 0)

	return {q, r, s}
}

hex_index :: proc(h: Hex) -> string {
	return fmt.tprintf("%02d%02d", i32(h.x + 1), i32(h.y + 1))
}

hex_lerp :: proc(a, b: Hex, t: f32) -> Hex {
	return math.lerp(a, b, t)
}

hex_to_pixel :: proc(layout: Layout, h: Hex) -> Point {
	M := layout.orientation
	size := layout.size
	origin := layout.origin

	x := (M.f0 * h.x + M.f1 * h.y) * size.x
	y := (M.f2 * h.x + M.f3 * h.y) * size.y

	return new_point(x + origin.x, y + origin.y)
}

hex_round :: proc(h: Hex) -> Hex {
	q := math.round(h.x)
	r := math.round(h.y)
	s := math.round(h.z)

	q_diff := math.abs(q - h.x)
	r_diff := math.abs(r - h.y)
	s_diff := math.abs(s - h.z)

	if q_diff > r_diff && q_diff > s_diff {
		q = -r - s
	} else if r_diff > s_diff {
		r = -q - s
	} else {
		s = -q - r
	}

	return new_hex(q, r, s)
}
