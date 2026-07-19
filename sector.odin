/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:encoding/csv"
import "core:math"
import "core:os"
import "core:path/filepath"
import "core:strings"
import rl "vendor:raylib"

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

	reader := csv.Reader {
		comma               = '\t',
		comment             = '#',
		fields_per_record   = -1,
		reuse_record        = true,
		reuse_record_buffer = true,
	}
	defer csv.reader_destroy(&reader)

	data := os.read_entire_file(path, context.allocator) or_return
	defer delete(data)

	csv.reader_init_with_string(&reader, string(data))

	for record, _, err in csv.iterator_next(&reader) {
		if err != nil {
			return sector, err
		}

		if system := &systems[record[2]]; system != nil {
			system.name = strings.clone_to_cstring(record[3])
			system.world = true
		}
	}

	layout := new_layout(flat_orientation(), origin, {HEX_SIZE, HEX_SIZE})

	return {name, systems, layout}, nil
}

delete_sector :: proc(sector: Sector) {
	delete(sector.name)

	for _, system in sector.systems {
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
		draw_system(sector, strings.clone_to_cstring(index), system)
	}

	position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
	hovered := pixel_to_hex_rounded(sector.layout, position)

	if contains_hex(hovered) {
		draw_hex(sector.layout, hovered, rl.RED)
	}
}
