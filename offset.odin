/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

ODD_OFFSET :: -1

Offset :: rl.Vector2

qoffset_from_cube :: proc(hex: Hex) -> Offset {
	col := hex.x
	row := hex.y + (col + ODD_OFFSET * f32(i32(col) & 1)) / 2

	return {col, row}
}

qoffset_to_cube :: proc(offset: Offset) -> (Hex, Error) {
	q := offset.x
	r := offset.y - (q + ODD_OFFSET * f32(i32(q) & 1)) / 2
	s := -q - r

	return new_hex(q, r, s)
}
