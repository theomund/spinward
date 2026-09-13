/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

SUBSECTOR_COLUMNS :: 8
SUBSECTOR_ROWS :: 10

SUBSECTOR_TITLE_SIZE :: SECTOR_TITLE_SIZE / 4
SUBSECTOR_TITLE_SPACING :: SECTOR_TITLE_SPACING / 4

Subsector :: struct {
	name:    Text,
	center:  Point,
	layout:  Layout,
	systems: [SUBSECTOR_ROWS][SUBSECTOR_COLUMNS]System,
	visible: bool,
}

new_subsector :: proc(layout: Layout, origin: Point) -> (subsector: Subsector, err: Error) {
	left := 0
	right := SUBSECTOR_COLUMNS
	top := 0
	bottom := SUBSECTOR_ROWS - 1

	for q := left; q < right; q += 1 {
		q_offset := q >> 1
		for r := top - q_offset; r <= bottom - q_offset; r += 1 {
			hex := new_hex(f32(q), f32(r), f32(-q - r)) or_return
			offset := qoffset_from_cube(hex)

			x := i32(offset.x)
			y := i32(offset.y)

			rounded := pixel_to_hex_rounded(layout, origin) or_return

			subsector.systems[y][x] = System {
				origin = hex_to_pixel(layout, hex),
				offset = offset + qoffset_from_cube(rounded),
			}
		}
	}

	subsector.layout = layout
	subsector.layout.origin = origin
	subsector.center = grid_center(subsector.layout, SUBSECTOR_COLUMNS, SUBSECTOR_ROWS) or_return
	subsector.visible = true

	return
}

destroy_subsector :: proc(subsector: Subsector) -> Error {
	destroy_text(subsector.name) or_return

	for row in subsector.systems {
		for system in row {
			destroy_system(system) or_return
		}
	}

	return nil
}

subsector_index :: proc(index: Text) -> u8 {
	return index[0] - 'A'
}

draw_subsector :: proc(subsector: Subsector, camera: Camera) -> Error {
	for row in subsector.systems {
		for system in row {
			draw_system(subsector.layout, system, camera) or_return
		}
	}

	for row in subsector.systems {
		for system in row {
			draw_allegiance(subsector.layout, system, camera)
		}
	}

	p1_hex := qoffset_to_cube({0, 0}) or_return
	p1 := hex_to_pixel(subsector.layout, p1_hex)

	p2_hex := qoffset_to_cube({SUBSECTOR_COLUMNS - 1, SUBSECTOR_ROWS - 1}) or_return
	p2 := hex_to_pixel(subsector.layout, p2_hex)

	M := subsector.layout.orientation

	draw_rectangle(
		{
			p1.x - HEX_SIZE / (4.0 / 3.0),
			p1.y - HEX_SIZE * M.f[0][1],
			p2.x - p1.x + HEX_SIZE * M.f[0][0],
			p2.y - p1.y + HEX_SIZE * M.f[0][1],
		},
		rl.GRAY,
	)

	draw_text(
		subsector.name,
		subsector.center,
		SUBSECTOR_TITLE_SIZE,
		SUBSECTOR_TITLE_SPACING,
		fade_color(rl.WHITE, camera.zoom, 0.5, 0.25),
	) or_return

	return nil
}
