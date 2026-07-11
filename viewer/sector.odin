/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

Sector :: struct {
	name:   cstring,
	hexes:  [SECTOR_ROWS][SECTOR_COLUMNS]Hex,
	origin: Coordinate,
}

new_sector :: proc(name: cstring, origin: Coordinate) -> Sector {
	hexes: [SECTOR_ROWS][SECTOR_COLUMNS]Hex

	for &row, y in hexes {
		for &hex, x in row {
			hex = oddq_to_axial({origin.col + i32(x), origin.row + i32(y)})
		}
	}

	return {name, hexes, origin}
}

draw_sector :: proc(sector: Sector) {
	for row in sector.hexes {
		for hex in row {
			draw_hex(hex)
		}
	}
}
