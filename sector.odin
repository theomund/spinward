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
	name:       Text,
	center:     Point,
	layout:     Layout,
	subsectors: [SECTOR_ROWS][SECTOR_COLUMNS]Subsector,
	visible:    bool,
}

new_sector :: proc() -> (sector: Sector) {
	sector.layout = flat_layout({0, 0})
	sector.center = grid_center(sector.layout, SECTOR_WIDTH, SECTOR_HEIGHT)
	sector.visible = true

	for y in 0 ..< SECTOR_ROWS {
		for x in 0 ..< SECTOR_COLUMNS {
			hex := qoffset_to_cube(new_offset(f32(x) * SUBSECTOR_COLUMNS, f32(y) * SUBSECTOR_ROWS))
			origin := hex_to_pixel(sector.layout, hex)

			sector.subsectors[y][x] = new_subsector(sector.layout, origin)
		}
	}

	return
}

destroy_sector :: proc(sector: Sector) -> Error {
	destroy_text(sector.name) or_return

	for row in sector.subsectors {
		for subsector in row {
			destroy_subsector(subsector) or_return
		}
	}

	return nil
}

contains_hex :: proc(hex: Hex) -> bool {
	offset := qoffset_from_cube(hex)

	return offset.x >= 0 && offset.y >= 0 && offset.x < SECTOR_WIDTH && offset.y < SECTOR_HEIGHT
}

draw_sector :: proc(sector: Sector, camera: Camera) -> Error {
	for row in sector.subsectors {
		for subsector in row {
			if subsector.visible {
				draw_subsector(subsector, camera) or_return
			}
		}
	}

	draw_hovered_hex(sector.layout, camera)
	draw_sector_title(sector, camera) or_return

	return nil
}

draw_hovered_hex :: proc(layout: Layout, camera: Camera) {
	position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
	hovered := pixel_to_hex_rounded(layout, position)

	if contains_hex(hovered) {
		draw_hex(layout, hovered, rl.YELLOW)
	}
}

draw_sector_title :: proc(sector: Sector, camera: Camera) -> Error {
	color := fade_color(rl.WHITE, camera.zoom, 0.5, 0.25)

	draw_text(sector.name, sector.center, SECTOR_TITLE_SIZE, SECTOR_TITLE_SPACING, color) or_return

	return nil
}
