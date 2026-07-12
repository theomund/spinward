/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

Sector :: struct {
	name:   cstring,
	hexes:  map[string]Hex,
	layout: Layout,
}

new_sector :: proc(name: cstring, origin: Point = {0, 0}) -> Sector {
	hexes: map[string]Hex

	layout := new_layout(flat_orientation(), origin, {SECTOR_ROWS, SECTOR_COLUMNS})

	return {name, hexes, layout}
}

draw_sector :: proc(sector: Sector) {
	for _, hex in sector.hexes {
		draw_hex(hex)
	}
}
