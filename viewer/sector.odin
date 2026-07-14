/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import rl "vendor:raylib"

Sector :: struct {
	name:   cstring,
	hexes:  map[string]Hex(int),
	layout: Layout,
}

new_sector :: proc(
	name: cstring,
	origin: Point = {0, 0},
	size: Point = {SECTOR_COLUMNS, SECTOR_ROWS},
) -> Sector {
	hexes: map[string]Hex(int)

	for y in 0 ..< int(size.y) {
		for x in 0 ..< int(size.x) {
			index := hex_index(x, y)
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

draw_hex :: proc(layout: Layout, hex: Hex(int)) {
	center := hex_to_pixel(layout, hex)
	rl.DrawPolyLines(point_to_vector(center), 6, HEX_SIZE, 0, rl.DARKGRAY)
}
