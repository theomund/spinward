/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

FONT_SIZE :: 16
FONT_SPACING :: 2

WORLD_SIZE :: 12

System :: struct {
	name:       cstring,
	allegiance: cstring,
	hex:        Hex,
}

new_system :: proc(hex: Hex) -> System {
	return {hex = hex}
}

delete_system :: proc(system: System) {
	if system.name != "" {
		delete(system.name)
	}

	if system.allegiance != "" {
		delete(system.allegiance)
	}
}

draw_border :: proc(sector: Sector, system: System) {
	color: rl.Color

	switch system.allegiance {
	case "DaCf":
		color = rl.WHITE
	case "ImDd":
		color = rl.RED
	case "SwCf":
		color = rl.DARKBLUE
	case "ZhIN":
		color = rl.BLUE
	}

	draw_hex(sector.layout, system.hex, color)
}

draw_system :: proc(sector: Sector, index: cstring, system: System) {
	draw_hex(sector.layout, system.hex, rl.DARKGRAY)

	center := hex_to_pixel(sector.layout, system.hex)

	if system.name != "" {
		rl.DrawCircle(i32(center.x), i32(center.y), WORLD_SIZE, rl.BLUE)
	}

	font := rl.GetFontDefault()
	name_size := rl.MeasureTextEx(font, system.name, FONT_SIZE, FONT_SPACING)
	index_size := rl.MeasureTextEx(font, index, FONT_SIZE, FONT_SPACING)

	rl.DrawTextEx(
		font,
		system.name,
		{center.x - (name_size.x / 2), (center.y - (HEX_SIZE / 2)) - (name_size.y / 2)},
		FONT_SIZE,
		FONT_SPACING,
		rl.WHITE,
	)
	rl.DrawTextEx(
		font,
		index,
		{center.x - (index_size.x / 2), (center.y + (HEX_SIZE / 2)) - (index_size.y / 2)},
		FONT_SIZE,
		FONT_SPACING,
		rl.DARKGRAY,
	)
}
