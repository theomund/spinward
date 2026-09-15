/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import rl "vendor:raylib"

FONT_SIZE :: 16
FONT_SPACING :: 2

System :: struct {
	name:       Text,
	allegiance: Allegiance,
	index:      Text,
	label:      Text,
	offset:     Offset,
	origin:     Point,
	visited:    bool,
	world:      bool,
}

destroy_system :: proc(system: System) -> Error {
	destroy_text(system.index) or_return
	destroy_text(system.label) or_return
	destroy_text(system.name) or_return

	return nil
}

system_index :: proc(index: string) -> (offset: Offset, err: Error) {
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

draw_system :: proc(system: System, zoom: f32) {
	if color := fade_color(rl.DARKGRAY, zoom, 0.25, 0.5); color.a != 0 {
		draw_hex(system.origin, fade_color(rl.DARKGRAY, zoom, 0.25, 0.5))
	}

	if system.world {
		draw_world(system.origin, zoom)
	}

	draw_text(system.name, zoom, 0.25, 0.5)
	draw_text(system.index, zoom, 0.25, 0.5)
	draw_text(system.label, zoom, 0.05, 0.25)

	draw_allegiance(system)
}
