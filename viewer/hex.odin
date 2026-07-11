/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import rl "vendor:raylib"

Hex :: struct {
	q, r: i32,
}

new_hex :: proc(q: i32, r: i32) -> Hex {
	return {q, r}
}

draw_hex :: proc(hex: Hex) {
	center := oddq_offset_to_pixel(axial_to_oddq(hex))
	rl.DrawPolyLines(center, 6, HEX_SIZE, 0, rl.WHITE)
}

axial_to_oddq :: proc(hex: Hex) -> Coordinate {
	parity := hex.q & 1
	col := hex.q
	row := hex.r + (hex.q - parity) / 2

	return new_coordinate(col, row)
}
