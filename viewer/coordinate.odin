/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import "core:math"
import rl "vendor:raylib"

Coordinate :: struct {
	col, row: i32,
}

new_coordinate :: proc(col, row: i32) -> Coordinate {
	return {col, row}
}

oddq_to_axial :: proc(coord: Coordinate) -> Hex {
	parity := coord.col & 1
	q := coord.col
	r := coord.row - (coord.col - parity) / 2

	return new_hex(q, r)
}

oddq_offset_to_pixel :: proc(coord: Coordinate) -> rl.Vector2 {
	x := 3 / 2 * f32(coord.col)
	y := math.SQRT_THREE * (f32(coord.row) + 0.5 * f32(coord.col & 1))
	x *= HEX_SIZE
	y *= HEX_SIZE

	return {x, y}
}
