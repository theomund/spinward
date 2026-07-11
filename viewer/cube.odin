/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import "base:intrinsics"
import "core:math"

Cube :: struct($T: typeid) where intrinsics.type_is_numeric(T) {
	q, r, s: T,
}

new_cube :: proc(q, r, s: $T) -> Cube(T) {
	return {q, r, s}
}

axial_to_cube :: proc(hex: Hex($T)) -> Cube(T) {
	q := hex.q
	r := hex.r
	s := -q - r

	return new_cube(q, r, s)
}

cube_to_axial :: proc(cube: Cube(i32)) -> Hex(i32) {
	q := cube.q
	r := cube.r

	return new_hex(q, r)
}

cube_round :: proc(frac: Cube(f32)) -> Cube(i32) {
	q := math.round(frac.q)
	r := math.round(frac.r)
	s := math.round(frac.s)

	q_diff := math.abs(q - frac.q)
	r_diff := math.abs(r - frac.r)
	s_diff := math.abs(s - frac.s)

	if q_diff > r_diff && q_diff > s_diff {
		q = -r - s
	} else if r_diff > s_diff {
		r = -q - s
	} else {
		s = -q - r
	}

	return new_cube(i32(q), i32(r), i32(s))
}
