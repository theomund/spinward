/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Hex :: rl.Vector3

new_hex :: proc(q, r, s: f32) -> Hex {
	assert(q + r + s == 0)

	return {q, r, s}
}

hex_index :: proc(x, y: i32) -> string {
	return fmt.tprintf("%02d%02d", x + 1, y + 1)
}

hex_to_pixel :: proc(layout: Layout, h: Hex) -> Point {
	M := layout.orientation

	x := (M.f[0][0] * h.x + M.f[0][1] * h.y) * layout.size.x
	y := (M.f[1][0] * h.x + M.f[1][1] * h.y) * layout.size.y

	return new_point(x + layout.origin.x, y + layout.origin.y)
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
