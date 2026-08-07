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

	screen_rect := new_rectangle(p1.x, p1.y, p2.x - p1.x, p2.y - p1.y)

	for _, &sector in sectors {
		check_sector_visibility(&sector, screen_rect)

		for &row in sector.subsectors {
			for &subsector in row {
				check_subsector_visibility(&subsector, screen_rect)
			}
		}
	}
}

check_sector_visibility :: proc(sector: ^Sector, screen_rect: Rectangle) {
	p1 := hex_to_pixel(sector.layout, qoffset_to_cube(new_offset(0, 0)))
	p2 := hex_to_pixel(
		sector.layout,
		qoffset_to_cube(new_offset(SECTOR_WIDTH - 1, SECTOR_HEIGHT - 1)),
	)

	x := p1.x - HEX_SIZE / (4.0 / 3.0)
	y := p1.y - HEX_SIZE * (math.SQRT_THREE / 2.0)

	width := p2.x - p1.x + HEX_SIZE * 1.5
	height := p2.y - p1.y + HEX_SIZE * (math.SQRT_THREE / 2.0)

	sector_rect := new_rectangle(x, y, width, height)

	sector.visible = rl.CheckCollisionRecs(screen_rect, sector_rect) ? true : false
}

check_subsector_visibility :: proc(subsector: ^Subsector, screen_rect: Rectangle) {
	p1 := hex_to_pixel(subsector.layout, qoffset_to_cube(new_offset(0, 0)))
	p2 := hex_to_pixel(
		subsector.layout,
		qoffset_to_cube(new_offset(SUBSECTOR_COLUMNS - 1, SUBSECTOR_ROWS - 1)),
	)

	x := p1.x - HEX_SIZE / (4.0 / 3.0)
	y := p1.y - HEX_SIZE * (math.SQRT_THREE / 2.0)

	width := p2.x - p1.x + HEX_SIZE * 1.5
	height := p2.y - p1.y + HEX_SIZE * (math.SQRT_THREE / 2.0)

	subsector_rect := new_rectangle(x, y, width, height)

	subsector.visible = rl.CheckCollisionRecs(screen_rect, subsector_rect) ? true : false
}
