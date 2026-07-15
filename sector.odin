/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import rl "vendor:raylib"

new_sector :: proc(
	name: cstring,
	origin: Point = {0, 0},
	size: Point = {SECTOR_COLUMNS, SECTOR_ROWS},
) -> Sector {
	hexes: map[string]Hex

	left := origin.x
	right := size.x
	top := origin.y
	bottom := size.y

	for q := left; q <= right; q += 1 {
		q_offset := math.floor(q / 2.0)
		for r := top - q_offset; r <= bottom - q_offset; r += 1 {
			hex := new_hex(q, r, -q - r)
			index := hex_index(hex)
			hexes[index] = hex
		}
	}

	layout := new_layout(flat_orientation(), origin, size)

	return {name, hexes, layout}
}

draw_sector :: proc(sector: Sector) {
	for _, hex in sector.hexes {
		draw_hex(sector.layout, hex)
	}
}

draw_hex :: proc(layout: Layout, h: Hex) {
	center := hex_to_pixel(layout, h)
	rl.DrawPolyLines(center, 6, HEX_SIZE, 0, rl.DARKGRAY)
}
