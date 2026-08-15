/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import "core:strconv"
import rl "vendor:raylib"

FONT_SIZE :: 16
FONT_SPACING :: 2

WORLD_SIZE :: 12

System :: struct {
	name:       Text,
	allegiance: Allegiance,
	hex:        Hex,
	index:      Text,
	label:      Text,
	visited:    bool,
	world:      bool,
}

new_system :: proc(hex: Hex, index: Text) -> System {
	return {hex = hex, index = index}
}

destroy_system :: proc(system: System) -> Error {
	destroy_text(system.name) or_return
	destroy_text(system.index) or_return
	destroy_text(system.label) or_return

	return nil
}

system_index :: proc(index: Text) -> (int, int, Error) {
	x, x_ok := strconv.parse_int(index[0:2], 10)
	if !x_ok {
		return x, 0, .Invalid_Index
	}

	y, y_ok := strconv.parse_int(index[2:4], 10)
	if !y_ok {
		return x, y, .Invalid_Index
	}

	return x - 1, y - 1, nil
}

get_system :: proc(sector: ^Sector, x, y: int) -> ^System {
	col := math.clamp(x, 0, 31)
	row := math.clamp(y, 0, 39)

	subsector := &sector.subsectors[row / SUBSECTOR_ROWS][col / SUBSECTOR_COLUMNS]
	system := &subsector.systems[row % SUBSECTOR_ROWS][col % SUBSECTOR_COLUMNS]

	return system
}

draw_system :: proc(layout: Layout, system: System, camera: Camera) -> Error {
	center := hex_to_pixel(layout, system.hex)

	color := fade_color(rl.DARKGRAY, camera.zoom, 0.25, 0.5)

	if color.a != 0 {
		draw_hex(layout, system.hex, color)
	}

	if system.world {
		rl.DrawCircleV(center, WORLD_SIZE, rl.BLUE)
	}

	color = fade_color(rl.WHITE, camera.zoom, 0.25, 0.5)
	draw_text(system.name, center - {0, HEX_SIZE / 2}, FONT_SIZE, FONT_SPACING, color) or_return

	color = fade_color(rl.DARKGRAY, camera.zoom, 0.25, 0.5)
	draw_text(system.index, center + {0, HEX_SIZE / 2}, FONT_SIZE, FONT_SPACING, color) or_return

	color = fade_color(rl.YELLOW, camera.zoom, 0.5, 0.25)
	draw_text(system.label, center, SUBSECTOR_TITLE_SIZE, SUBSECTOR_TITLE_SPACING, color) or_return

	return nil
}
