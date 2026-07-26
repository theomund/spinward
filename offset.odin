/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

ODD_OFFSET :: -1

Offset :: rl.Vector2

new_offset :: proc(col, row: f32) -> Offset {
	return {col, row}
}

qoffset_from_cube :: proc(hex: Hex) -> Offset {
	col := hex.x
	row := hex.y + (hex.x + ODD_OFFSET * f32(i32(hex.x) & 1)) / 2

	return new_offset(col, row)
}

qoffset_to_cube :: proc(offset: Offset) -> Hex {
	q := offset.x
	r := offset.y - (offset.x + ODD_OFFSET * f32(i32(offset.x) & 1)) / 2
	s := -q - r

	return new_hex(q, r, s)
}
