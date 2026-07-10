/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import rl "vendor:raylib"

Sector :: struct {
	name:   string,
	hexes:  [SECTOR_SIZE]Hex,
	origin: rl.Vector2,
}

new_sector :: proc(
	name: string,
	origin: rl.Vector2 = {WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2},
) -> Sector {
	hexes: [SECTOR_SIZE]Hex

	for &hex in hexes {
		hex = new_hex("Unknown", origin)
	}

	return {name, hexes, origin}
}

draw_sector :: proc(sector: Sector) {
	for hex in sector.hexes {
		draw_hex(hex)
	}
}
