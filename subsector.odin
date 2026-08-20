/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
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

new_subsector :: proc(layout: Layout, origin: Point) -> Subsector {
	left := 0
	right := SUBSECTOR_COLUMNS
	top := 0
	bottom := SUBSECTOR_ROWS - 1

	systems: [SUBSECTOR_ROWS][SUBSECTOR_COLUMNS]System

	for q := left; q < right; q += 1 {
		q_offset := q >> 1
		for r := top - q_offset; r <= bottom - q_offset; r += 1 {
			hex := new_hex(f32(q), f32(r), f32(-q - r))
			offset := qoffset_from_cube(hex)

			x := i32(offset.x)
			y := i32(offset.y)

			system_index := hex_index(hex + pixel_to_hex_rounded(layout, origin))
			systems[y][x] = new_system(hex, system_index)
		}
	}

	subsector_layout := layout
	subsector_layout.origin = origin

	return {
		center = grid_center(subsector_layout, SUBSECTOR_COLUMNS, SUBSECTOR_ROWS),
		layout = subsector_layout,
		systems = systems,
		visible = true,
	}
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

	draw_subsector_border(subsector)
	draw_subsector_title(subsector, camera) or_return

	return nil
}

draw_subsector_border :: proc(subsector: Subsector) {
	p1 := hex_to_pixel(subsector.layout, qoffset_to_cube(new_offset(0, 0)))
	p2 := hex_to_pixel(
		subsector.layout,
		qoffset_to_cube(new_offset(SUBSECTOR_COLUMNS - 1, SUBSECTOR_ROWS - 1)),
	)

	x := p1.x - HEX_SIZE / (4.0 / 3.0)
	y := p1.y - HEX_SIZE * (math.SQRT_THREE / 2.0)

	width := p2.x - p1.x + HEX_SIZE * 1.5
	height := p2.y - p1.y + HEX_SIZE * (math.SQRT_THREE / 2.0)

	rectangle := new_rectangle(x, y, width, height)
	draw_rectangle(rectangle, rl.GRAY)
}

draw_subsector_title :: proc(subsector: Subsector, camera: Camera) -> Error {
	color := fade_color(rl.WHITE, camera.zoom, 0.5, 0.25)

	draw_text(
		subsector.name,
		subsector.center,
		SUBSECTOR_TITLE_SIZE,
		SUBSECTOR_TITLE_SPACING,
		color,
	) or_return

	return nil
}
