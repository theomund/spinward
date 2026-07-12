/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import rl "vendor:raylib"

Sector :: struct {
	name:   cstring,
	hexes:  map[string]Hex,
	layout: Layout,
}

new_sector :: proc(
	name: cstring,
	origin: Point = {0, 0},
	size: Point = {SECTOR_COLUMNS, SECTOR_ROWS},
) -> Sector {
	hexes: map[string]Hex

	for y in 0 ..< size.y {
		for x in 0 ..< size.x {
			index := hex_index(i32(x), i32(y))
			hexes[index] = new_hex(x, y, -x - y)
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

draw_hex :: proc(layout: Layout, hex: Hex) {
	center := hex_to_pixel(layout, hex)
	rl.DrawPolyLines(center, 6, HEX_SIZE, 0, rl.DARKGRAY)
}
