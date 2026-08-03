/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:strconv"
import rl "vendor:raylib"

FONT_SIZE :: 16
FONT_SPACING :: 2

WORLD_SIZE :: 12

System :: struct {
	name:       cstring,
	allegiance: Allegiance,
	hex:        Hex,
	index:      cstring,
	label:      cstring,
	world:      bool,
}

new_system :: proc(
	name: cstring = "",
	allegiance: Allegiance = .Unaligned,
	hex: Hex,
	index: cstring = "",
	label: cstring = "",
	world := false,
) -> System {
	return {name, allegiance, hex, index, label, world}
}

destroy_system :: proc(system: System) {
	if system.name != "" && system.name != "????" {
		delete(system.name)
	}

	if system.index != "" {
		delete(system.index)
	}
}

system_index :: proc(index: string) -> (int, int, Error) {
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

draw_system :: proc(layout: Layout, system: System, camera: Camera) {
	draw_hex(layout, system.hex, rl.DARKGRAY)

	center := hex_to_pixel(layout, system.hex)

	if system.world {
		rl.DrawCircle(i32(center.x), i32(center.y), WORLD_SIZE, rl.BLUE)
	}

	color := rl.WHITE
	color.a = fade(camera.zoom, 0.25, 0.5)

	draw_text(system.name, center - {0, HEX_SIZE / 2}, FONT_SIZE, FONT_SPACING, color)

	color = rl.DARKGRAY
	color.a = fade(camera.zoom, 0.25, 0.5)

	draw_text(system.index, center + {0, HEX_SIZE / 2}, FONT_SIZE, FONT_SPACING, color)

	color = rl.YELLOW
	color.a = fade(camera.zoom, 0.5, 0.25)

	draw_text(system.label, center, SUBSECTOR_TITLE_SIZE, SUBSECTOR_TITLE_SPACING, color)
}
