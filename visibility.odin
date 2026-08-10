/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import rl "vendor:raylib"

check_visibility :: proc(sectors: map[string]Sector, camera: Camera) {
	p1 := rl.GetScreenToWorld2D({0, 0}, camera)
	p2 := rl.GetScreenToWorld2D({WINDOW_WIDTH, WINDOW_HEIGHT}, camera)

	screen := new_rectangle(p1.x, p1.y, p2.x - p1.x, p2.y - p1.y)

	for _, &sector in sectors {
		sector.visible = rectangle_visible(sector.layout, screen, SECTOR_WIDTH, SECTOR_HEIGHT)

		for &row in sector.subsectors {
			for &subsector in row {
				subsector.visible = rectangle_visible(
					subsector.layout,
					screen,
					SUBSECTOR_COLUMNS,
					SUBSECTOR_ROWS,
				)
			}
		}
	}
}

rectangle_visible :: proc(layout: Layout, screen: Rectangle, col, row: f32) -> bool {
	p1 := hex_to_pixel(layout, qoffset_to_cube(new_offset(0, 0)))
	p2 := hex_to_pixel(layout, qoffset_to_cube(new_offset(col - 1, row - 1)))

	x := p1.x - HEX_SIZE / (4.0 / 3.0)
	y := p1.y - HEX_SIZE * (math.SQRT_THREE / 2.0)

	width := p2.x - p1.x + HEX_SIZE * 1.5
	height := p2.y - p1.y + HEX_SIZE * (math.SQRT_THREE / 2.0)

	rect := new_rectangle(x, y, width, height)

	return rl.CheckCollisionRecs(screen, rect)
}
