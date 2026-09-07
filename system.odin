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
	hex:        Hex,
	label:      Text,
	offset:     Offset,
	visited:    bool,
	world:      bool,
}

new_system :: proc(hex: Hex, index: Text) -> (system: System, err: Error) {
	system.hex = hex
	system.offset = system_index(index) or_return

	return
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

draw_system :: proc(layout: Layout, system: System, camera: Camera) -> Error {
	center := hex_to_pixel(layout, system.hex)

	draw_hex(layout, system.hex, fade_color(rl.DARKGRAY, camera.zoom, 0.25, 0.5))

	if system.world {
		rl.DrawCircleV(center, WORLD_SIZE, rl.BLUE)
	}

	draw_text(
		system.name,
		center - {0, HALF_HEX},
		FONT_SIZE,
		FONT_SPACING,
		fade_color(rl.WHITE, camera.zoom, 0.25, 0.5),
	) or_return

	draw_text(
		fmt.tprintf("%02d%02d", int(system.offset.x + 1), int(system.offset.y + 1)),
		center + {0, HALF_HEX},
		FONT_SIZE,
		FONT_SPACING,
		fade_color(rl.DARKGRAY, camera.zoom, 0.25, 0.5),
	) or_return

	draw_text(
		system.label,
		center,
		SUBSECTOR_TITLE_SIZE,
		SUBSECTOR_TITLE_SPACING,
		fade_color(rl.YELLOW, camera.zoom, 0.5, 0.25),
	) or_return

	return nil
}
