/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import "core:strings"
import rl "vendor:raylib"

new_sector :: proc(name: string, origin: Point = {0, 0}) -> Sector {
	hexes: map[string]Hex

	left := origin.x
	right := origin.x + SECTOR_COLUMNS
	top := origin.y
	bottom := origin.y + SECTOR_ROWS - 1

	for q := left; q < right; q += 1 {
		q_offset := math.floor(q / 2.0)
		for r := top - q_offset; r <= bottom - q_offset; r += 1 {
			hex := new_hex(q, r, -q - r)
			index := hex_index(hex)
			hexes[index] = hex
		}
	}

	layout := new_layout(flat_orientation(), origin, {HEX_SIZE, HEX_SIZE})

	return {name, hexes, layout}
}

delete_sector :: proc(sector: Sector) {
	delete(sector.hexes)
}

contains_hex :: proc(hex: Hex) -> bool {
	offset := qoffset_from_cube(hex)

	return offset.x >= 0 && offset.y >= 0 && offset.x < SECTOR_COLUMNS && offset.y < SECTOR_ROWS
}

draw_sector :: proc(sector: Sector, camera: rl.Camera2D) {
	for _, hex in sector.hexes {
		draw_hex(sector.layout, hex, rl.DARKGRAY)
	}

	position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
	hovered := pixel_to_hex_rounded(sector.layout, position)

	if contains_hex(hovered) {
		index := strings.clone_to_cstring(hex_index(hovered))

		rl.DrawText(index, i32(position.x), i32(position.y - 8), 8, rl.WHITE)

		draw_hex(sector.layout, hovered, rl.RED)
	}
}

draw_hex :: proc(layout: Layout, hex: Hex, color: rl.Color) {
	center := hex_to_pixel(layout, hex)

	rl.DrawPolyLines(center, 6, HEX_SIZE, 0, color)
}
