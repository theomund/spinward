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
	name:      Text,
	center:    Point,
	layout:    Layout,
	rectangle: Rectangle,
	systems:   [SUBSECTOR_ROWS][SUBSECTOR_COLUMNS]System,
	visible:   bool,
}

new_subsector :: proc(layout: Layout, origin: Point) -> (subsector: Subsector, err: Error) {
	for q in 0 ..< SUBSECTOR_COLUMNS {
		q_offset := q >> 1

		for r in -q_offset ..< SUBSECTOR_ROWS - q_offset {
			hex := new_hex(f32(q), f32(r), f32(-q - r)) or_return
			offset := qoffset_from_cube(hex)

			rounded := pixel_to_hex_rounded(layout, origin) or_return

			subsector.systems[i32(offset.y)][i32(offset.x)] = System {
				origin = hex_to_pixel(layout, hex),
				offset = offset + qoffset_from_cube(rounded),
			}
		}
	}

	subsector.layout = layout
	subsector.layout.origin = origin
	subsector.center = grid_center(subsector.layout, SUBSECTOR_COLUMNS, SUBSECTOR_ROWS) or_return
	subsector.rectangle = new_rectangle(
		subsector.layout,
		SUBSECTOR_COLUMNS,
		SUBSECTOR_ROWS,
	) or_return
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
			draw_system(system, camera) or_return
		}
	}

	draw_rectangle(subsector.rectangle, rl.GRAY)

	draw_text(
		subsector.name,
		subsector.center,
		SUBSECTOR_TITLE_SIZE,
		SUBSECTOR_TITLE_SPACING,
		fade_color(rl.WHITE, camera.zoom, 0.5, 0.25),
	) or_return

	return nil
}
