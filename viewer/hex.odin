/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import "base:intrinsics"
import "core:math"
import rl "vendor:raylib"

Hex :: struct($T: typeid) where intrinsics.type_is_numeric(T) {
	q, r: T,
}

new_hex :: proc(q, r: $T) -> Hex(T) {
	return {q, r}
}

draw_hex :: proc(hex: Hex(i32)) {
	center := oddq_offset_to_pixel(axial_to_oddq(hex))
	rl.DrawPolyLines(center, 6, HEX_SIZE, 0, rl.DARKGRAY)
}

axial_to_oddq :: proc(hex: Hex(i32)) -> Coordinate {
	parity := hex.q & 1
	col := hex.q
	row := hex.r + (hex.q - parity) / 2

	return new_coordinate(col, row)
}

pixel_to_flat_hex :: proc(point: rl.Vector2) -> Hex(i32) {
	x := point.x / HEX_SIZE
	y := point.y / HEX_SIZE
	q := ((2.0 / 3) * x)
	r := ((-1.0 / 3) * x + (math.SQRT_THREE / 3) * y)

	return axial_round(new_hex(q, r))
}

axial_round :: proc(frac: Hex(f32)) -> Hex(i32) {
	return cube_to_axial(cube_round(axial_to_cube(frac)))
}
