/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

check_visibility :: proc(sectors: []Sector, camera: Camera) -> Error {
	p1 := rl.GetScreenToWorld2D({0, 0}, camera)
	p2 := rl.GetScreenToWorld2D({WINDOW_WIDTH, WINDOW_HEIGHT}, camera)

	screen := Rectangle{p1.x, p1.y, p2.x - p1.x, p2.y - p1.y}

	for &sector in sectors {
		sector.visible = rectangle_visible(
			sector.layout,
			screen,
			SECTOR_WIDTH,
			SECTOR_HEIGHT,
		) or_return

		for &row in sector.subsectors {
			for &subsector in row {
				subsector.visible = rectangle_visible(
					subsector.layout,
					screen,
					SUBSECTOR_COLUMNS,
					SUBSECTOR_ROWS,
				) or_return
			}
		}
	}

	return nil
}

rectangle_visible :: proc(
	layout: Layout,
	screen: Rectangle,
	col, row: f32,
) -> (
	visible: bool,
	err: Error,
) {
	p1_hex := qoffset_to_cube({0, 0}) or_return
	p1 := hex_to_pixel(layout, p1_hex)

	p2_hex := qoffset_to_cube({col - 1, row - 1}) or_return
	p2 := hex_to_pixel(layout, p2_hex)

	M := layout.orientation

	x := p1.x - HEX_SIZE / (4.0 / 3.0)
	y := p1.y - HEX_SIZE * M.f[0][1]

	width := p2.x - p1.x + HEX_SIZE * M.f[0][0]
	height := p2.y - p1.y + HEX_SIZE * M.f[0][1]

	rect := Rectangle{x, y, width, height}

	return rl.CheckCollisionRecs(screen, rect), nil
}
