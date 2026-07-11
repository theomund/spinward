/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import rl "vendor:raylib"

Sector :: struct {
	name:   string,
	hexes:  [SECTOR_ROWS][SECTOR_COLUMNS]Hex,
	origin: rl.Vector2,
}

new_sector :: proc(name: string, origin: rl.Vector2) -> Sector {
	hexes: [SECTOR_ROWS][SECTOR_COLUMNS]Hex

	for &row, y in hexes {
		for &hex, x in row {
			hex = oddq_to_axial({i32(x), i32(y)})
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
