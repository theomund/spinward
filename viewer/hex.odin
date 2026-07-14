/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import "base:intrinsics"
import "core:fmt"
import "core:math"

Hex :: struct($T: typeid) where intrinsics.type_is_numeric(T) {
	q, r, s: T,
}

new_hex :: proc(q, r, s: $T) -> Hex(T) {
	assert(math.round(f64(q + r + s)) == 0)

	return {q, r, s}
}

hex_index :: proc(x, y: int) -> string {
	return fmt.tprintf("%02d%02d", x + 1, y + 1)
}

hex_lerp :: proc(a, b: Hex(f64), t: f64) -> Hex(f64) {
	return new_hex(a.q * (1.0 - t) + b.q * t, a.r * (1.0 - t) + b.r * t, a.s * (1.0 - t) + b.s * t)
}

hex_to_pixel :: proc(layout: Layout, h: Hex(int)) -> Point {
	M := layout.orientation

	x := (M.f0 * f64(h.q) + M.f1 * f64(h.r)) * layout.size.x
	y := (M.f2 * f64(h.q) + M.f3 * f64(h.r)) * layout.size.y

	return new_point(x + layout.origin.x, y + layout.origin.y)
}

hex_round :: proc(h: Hex(f64)) -> Hex(int) {
	q := int(math.round(h.q))
	r := int(math.round(h.r))
	s := int(math.round(h.s))

	q_diff := math.abs(f64(q) - h.q)
	r_diff := math.abs(f64(r) - h.r)
	s_diff := math.abs(f64(s) - h.s)

	if q_diff > r_diff && q_diff > s_diff {
		q = -r - s
	} else if r_diff > s_diff {
		r = -q - s
	} else {
		s = -q - r
	}

	return new_hex(q, r, s)
}
