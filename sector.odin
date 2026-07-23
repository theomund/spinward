/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import "core:path/filepath"
import "core:strings"
import rl "vendor:raylib"

SECTOR_COLUMNS :: 32
SECTOR_ROWS :: 40

TITLE_SIZE :: 320
TITLE_SPACING :: 16

Sector :: struct {
	name:    cstring,
	systems: map[string]System,
	layout:  Layout,
}

new_sector :: proc(path: string, origin: Point = {0, 0}) -> (sector: Sector, err: Error) {
	name := strings.clone_to_cstring(filepath.short_stem(path))

	systems: map[string]System

	left := origin.x
	right := origin.x + SECTOR_COLUMNS
	top := origin.y
	bottom := origin.y + SECTOR_ROWS - 1

	for q := left; q < right; q += 1 {
		q_offset := math.floor(q / 2.0)
		for r := top - q_offset; r <= bottom - q_offset; r += 1 {
			hex := new_hex(q, r, -q - r)
			index := hex_index(hex)
			systems[index] = new_system(hex)
		}
	}

	reader := new_reader()
	defer destroy_reader(&reader)

	read_sector(&reader, path, systems)

	layout := new_layout(flat_orientation(), origin, {HEX_SIZE, HEX_SIZE})

	return {name, systems, layout}, nil
}

delete_sector :: proc(sector: Sector) {
	delete(sector.name)

	for index, system in sector.systems {
		delete(index)
		delete_system(system)
	}

	delete(sector.systems)
}

contains_hex :: proc(hex: Hex) -> bool {
	offset := qoffset_from_cube(hex)

	return offset.x >= 0 && offset.y >= 0 && offset.x < SECTOR_COLUMNS && offset.y < SECTOR_ROWS
}

draw_sector :: proc(sector: Sector, camera: rl.Camera2D) {
	for index, system in sector.systems {
		clone := strings.clone_to_cstring(index)
		defer delete(clone)

		draw_system(sector, clone, system)
	}

	for _, system in sector.systems {
		draw_border(sector, system)
	}

	position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
	hovered := pixel_to_hex_rounded(sector.layout, position)

	if contains_hex(hovered) {
		draw_hex(sector.layout, hovered, rl.YELLOW)
	}

	draw_title(sector, camera)
}

draw_title :: proc(sector: Sector, camera: rl.Camera2D) {
	minimum_hex := qoffset_to_cube(new_offset(0, 0))
	maximum_hex := qoffset_to_cube(new_offset(SECTOR_COLUMNS - 1, SECTOR_ROWS - 1))
	center_hex := (minimum_hex + maximum_hex) / 2
	center := hex_to_pixel(sector.layout, center_hex)

	font := rl.GetFontDefault()
	text_size := rl.MeasureTextEx(font, sector.name, TITLE_SIZE, TITLE_SPACING)

	position := Point{center.x - text_size.x / 2, center.y - text_size.y / 2}

	color := rl.WHITE
	color.a = fade(camera.zoom, 0.5, 0.25)

	rl.DrawTextEx(font, sector.name, position, TITLE_SIZE, TITLE_SPACING, color)
}
