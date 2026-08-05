/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

SECTOR_COLUMNS :: 4
SECTOR_ROWS :: 4

SECTOR_WIDTH :: SECTOR_COLUMNS * SUBSECTOR_COLUMNS
SECTOR_HEIGHT :: SECTOR_ROWS * SUBSECTOR_ROWS

SECTOR_TITLE_SIZE :: 320
SECTOR_TITLE_SPACING :: 16

Sector :: struct {
	name:       cstring,
	center:     Point,
	layout:     Layout,
	subsectors: [SECTOR_ROWS][SECTOR_COLUMNS]Subsector,
}

new_sector :: proc(name: cstring = "", origin: Point = {0, 0}) -> Sector {
	layout := flat_layout(origin)
	center := grid_center(layout, SECTOR_WIDTH, SECTOR_HEIGHT)

	subsectors: [SECTOR_ROWS][SECTOR_COLUMNS]Subsector

	for y in 0 ..< SECTOR_ROWS {
		for x in 0 ..< SECTOR_COLUMNS {
			subsector_hex := qoffset_to_cube(
				new_offset(f32(x) * SUBSECTOR_COLUMNS, f32(y) * SUBSECTOR_ROWS),
			)
			subsector_origin := hex_to_pixel(layout, subsector_hex)

			subsectors[y][x] = new_subsector(layout = layout, origin = subsector_origin)
		}
	}

	return {name, center, layout, subsectors}
}

destroy_sector :: proc(sector: Sector) {
	destroy_string(sector.name)

	for row in sector.subsectors {
		for subsector in row {
			destroy_subsector(subsector)
		}
	}
}

contains_hex :: proc(hex: Hex) -> bool {
	offset := qoffset_from_cube(hex)

	return offset.x >= 0 && offset.y >= 0 && offset.x < SECTOR_WIDTH && offset.y < SECTOR_HEIGHT
}

draw_sector :: proc(sector: Sector, camera: Camera) {
	for row in sector.subsectors {
		for subsector in row {
			draw_subsector(subsector, camera)
		}
	}

	draw_hovered_hex(sector.layout, camera)
	draw_sector_title(sector, camera)
}

draw_hovered_hex :: proc(layout: Layout, camera: Camera) {
	position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
	hovered := pixel_to_hex_rounded(layout, position)

	if contains_hex(hovered) {
		draw_hex(layout, hovered, rl.YELLOW)
	}
}

draw_sector_title :: proc(sector: Sector, camera: Camera) {
	color := rl.WHITE
	color.a = fade(camera.zoom, 0.5, 0.25)

	draw_text(sector.name, sector.center, SECTOR_TITLE_SIZE, SECTOR_TITLE_SPACING, color)
}
