/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

FONT_SIZE :: 16
FONT_SPACING :: 2

WORLD_SIZE :: 12

System :: struct {
	name:       Text,
	allegiance: Allegiance,
	label:      Text,
	offset:     Offset,
	origin:     Point,
	visited:    bool,
	world:      bool,
}

destroy_system :: proc(system: System) -> Error {
	destroy_text(system.name) or_return
	destroy_text(system.label) or_return

	return nil
}

system_index :: proc(index: Text) -> (offset: Offset, err: Error) {
	x := read_int(index[0:2]) or_return
	y := read_int(index[2:4]) or_return

	offset = {f32(x - 1), f32(y - 1)}

	return
}

get_system :: proc(sector: ^Sector, offset: Offset) -> ^System {
	col := math.clamp(int(offset.x), 0, 31)
	row := math.clamp(int(offset.y), 0, 39)

	subsector := &sector.subsectors[row / SUBSECTOR_ROWS][col / SUBSECTOR_COLUMNS]
	system := &subsector.systems[row % SUBSECTOR_ROWS][col % SUBSECTOR_COLUMNS]

	return system
}

draw_system :: proc(system: System, camera: Camera) -> Error {
	draw_hex(system.origin, fade_color(rl.DARKGRAY, camera.zoom, 0.25, 0.5))

	if system.world {
		rl.DrawCircleV(system.origin, WORLD_SIZE, rl.BLUE)
	}

	draw_text(
		system.name,
		system.origin - {0, HALF_HEX},
		FONT_SIZE,
		FONT_SPACING,
		fade_color(rl.WHITE, camera.zoom, 0.25, 0.5),
	) or_return

	draw_text(
		fmt.tprintf("%02d%02d", int(system.offset.x + 1), int(system.offset.y + 1)),
		system.origin + {0, HALF_HEX},
		FONT_SIZE,
		FONT_SPACING,
		fade_color(rl.DARKGRAY, camera.zoom, 0.25, 0.5),
	) or_return

	draw_text(
		system.label,
		system.origin,
		SUBSECTOR_TITLE_SIZE,
		SUBSECTOR_TITLE_SPACING,
		fade_color(rl.YELLOW, camera.zoom, 0.5, 0.25),
	) or_return

	draw_allegiance(system, camera)

	return nil
}
