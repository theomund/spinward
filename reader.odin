/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "base:runtime"
import "core:container/queue"
import "core:encoding/csv"
import "core:encoding/xml"
import "core:math/linalg"
import "core:path/filepath"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

Reader :: csv.Reader

read_sectors :: proc() -> (sectors: [dynamic]Sector, err: Error) {
	assets := #load_directory("assets")

	for asset in assets {
		if asset.name == "M1105.xml" {
			sector: Sector
			defer destroy_sector(sector)

			x, y: string

			read_xml(assets, asset.data, false, &sector, &sectors, &x, &y) or_return

			return
		}
	}

	return sectors, .Initialization_Failed
}

read_tab :: proc(sector: ^Sector, data: string) -> Error {
	reader := Reader {
		comma               = '\t',
		comment             = '#',
		fields_per_record   = -1,
		reuse_record        = true,
		reuse_record_buffer = true,
	}
	defer csv.reader_destroy(&reader)

	csv.reader_init_with_string(&reader, data)

	hex_index, allegiance_index, name_index: u32

	for record, _, err in csv.iterator_next(&reader) {
		if err != nil {
			return err
		}

		if record[0] == "Sector" {
			allegiance_index = 9
			hex_index = 2
			name_index = 3

			continue
		} else if record[0] == "Hex" {
			allegiance_index = 7
			hex_index = 0
			name_index = 1

			continue
		}

		offset := system_index(record[hex_index]) or_return
		system := get_system(sector, offset)

		system.allegiance = new_allegiance(record[allegiance_index])
		system.name = new_text(
			value = record[name_index] != "" ? record[name_index] : "????",
			origin = system.origin - {0, HALF_HEX},
		) or_return
		system.world = true
	}

	return nil
}

read_xml :: proc(
	assets: []runtime.Load_Directory_File,
	data: []u8,
	metadata: bool,
	sector: ^Sector,
	sectors: ^[dynamic]Sector,
	x, y: ^string,
) -> Error {
	document := xml.parse(data, allocator = context.temp_allocator) or_return

	for element in document.elements {
		switch element.ident {
		case "Border":
			read_border(element, sector) or_return
		case "DataFile":
			for file in assets {
				if file.name == read_value(element) && filepath.ext(file.name) == ".tab" {
					read_tab(sector, string(file.data)) or_return
				}
			}
		case "MetadataFile":
			for file in assets {
				if strings.to_lower(file.name, context.temp_allocator) ==
				   strings.to_lower(read_value(element), context.temp_allocator) {
					read_xml(assets, file.data, true, sector, sectors, x, y) or_return
				}
			}
		case "Name":
			read_name(element, sector) or_return
		case "Route":
			read_route(element, sector) or_return
		case "Sector":
			if !metadata {
				if x^ != "" && y^ != "" {
					read_coords(x^, y^, sector) or_return
					append(sectors, sector^) or_return

					x^ = ""
					y^ = ""
				}

				sector^ = new_sector() or_return
			}
		case "Subsector":
			read_subsector(element, sector) or_return
		case "X":
			if x^ == "" {
				x^ = read_value(element)
			}
		case "Y":
			if y^ == "" {
				y^ = read_value(element)
			}
		}
	}

	return nil
}

read_border :: proc(element: xml.Element, sector: ^Sector) -> Error {
	allegiance: Allegiance
	label: string
	label_position: string

	for attribute in element.attribs {
		switch attribute.key {
		case "Allegiance":
			allegiance = new_allegiance(attribute.val)
		case "Label":
			label = attribute.val
		case "LabelPosition":
			label_position = attribute.val
		}
	}

	if label == "" {
		label = allegiances[allegiance].label
	}

	if label_position != "" {
		offset := system_index(label_position) or_return

		system := get_system(sector, offset)
		system.label = new_text(
			label,
			system.origin,
			SUBSECTOR_TITLE_SIZE,
			SUBSECTOR_TITLE_SPACING,
			rl.YELLOW,
		) or_return
	}

	borders := strings.fields(read_value(element), context.temp_allocator) or_return

	offsets := make([dynamic]Offset, 0, context.temp_allocator)

	for border in borders {
		offset := system_index(border) or_return
		append(&offsets, offset)

		system := get_system(sector, offset)
		system.allegiance = allegiance
		system.visited = true
	}

	min_offset := offsets[0]
	max_offset := offsets[0]

	for offset in offsets[1:] {
		min_offset = linalg.min(min_offset, offset)
		max_offset = linalg.max(max_offset, offset)
	}

	min_offset -= {1, 1}
	max_offset += {1, 1}

	flood: queue.Queue(^System)
	queue.init(&flood, allocator = context.temp_allocator) or_return

	for i := min_offset.x; i < max_offset.x; i += 1 {
		if system := get_system(sector, {i, min_offset.y}); !system.visited {
			queue.push_back(&flood, system) or_return
		}
		if system := get_system(sector, {i, max_offset.y}); !system.visited {
			queue.push_back(&flood, system) or_return
		}
	}

	for i := min_offset.y; i < max_offset.y; i += 1 {
		if system := get_system(sector, {min_offset.x, i}); !system.visited {
			queue.push_back(&flood, system) or_return
		}
		if system := get_system(sector, {max_offset.x, i}); !system.visited {
			queue.push_back(&flood, system) or_return
		}
	}

	for queue.len(flood) != 0 {
		current := queue.pop_front(&flood)
		hex := qoffset_to_cube(current.offset) or_return

		for i in 0 ..< 6 {
			if system := get_system(sector, qoffset_from_cube(hex_neighbor(hex, i)));
			   !system.visited {
				system.visited = true
				queue.push_back(&flood, system) or_return
			}
		}
	}

	for y := 0; y < SECTOR_HEIGHT; y += 1 {
		for x := 0; x < SECTOR_WIDTH; x += 1 {
			if system := get_system(sector, {f32(x), f32(y)}); !system.visited {
				system.allegiance = allegiance
			} else {
				system.visited = false
			}
		}
	}

	return nil
}

read_name :: proc(element: xml.Element, sector: ^Sector) -> Error {
	if sector.name.content == "" {
		sector.name = new_text(
			read_value(element),
			sector.center,
			SECTOR_TITLE_SIZE,
			SECTOR_TITLE_SPACING,
		) or_return
	}

	return nil
}

read_route :: proc(element: xml.Element, sector: ^Sector) -> Error {
	allegiance: Allegiance
	start, start_offset, end, end_offset: Offset
	dashed: bool

	for attribute in element.attribs {
		switch attribute.key {
		case "Allegiance":
			allegiance = new_allegiance(attribute.val)
		case "Start":
			start = system_index(attribute.val) or_return
		case "End":
			end = system_index(attribute.val) or_return
		case "StartOffsetX":
			start_offset.x = read_f32(attribute.val) or_return
		case "StartOffsetY":
			start_offset.y = read_f32(attribute.val) or_return
		case "EndOffsetX":
			end_offset.x = read_f32(attribute.val) or_return
		case "EndOffsetY":
			end_offset.y = read_f32(attribute.val) or_return
		case "Style":
			dashed = attribute.val == "Dashed"
		case "Type":
			dashed = attribute.val == "Trade"
		}
	}

	route := new_route(
		allegiance,
		dashed,
		end_offset,
		end,
		sector.origin,
		start_offset,
		start,
	) or_return

	append(&sector.routes, route) or_return

	return nil
}

read_f32 :: proc(text: string) -> (f32, Error) {
	value, value_ok := strconv.parse_f32(text)
	if !value_ok {
		return value, .Invalid_Float
	}

	return value, nil
}

read_int :: proc(text: string) -> (int, Error) {
	value, value_ok := strconv.parse_int(text, 10)
	if !value_ok {
		return value, .Invalid_Int
	}

	return value, nil
}

read_subsector :: proc(element: xml.Element, sector: ^Sector) -> Error {
	for attribute in element.attribs {
		if attribute.key == "Index" {
			index := subsector_index(attribute.val)
			subsector := &sector.subsectors[index / SECTOR_ROWS][index % SECTOR_ROWS]

			subsector.name = new_text(
				read_value(element),
				subsector.center,
				SUBSECTOR_TITLE_SIZE,
				SUBSECTOR_TITLE_SPACING,
			) or_return

			return nil
		}
	}

	return .Invalid_Subsector
}

read_coords :: proc(x_text, y_text: string, sector: ^Sector) -> Error {
	x := read_f32(x_text) or_return
	y := read_f32(y_text) or_return

	sector.origin = {
		x * (M.f[0][0] * HEX_SIZE) * SECTOR_WIDTH,
		y * (M.f[1][1] * HEX_SIZE) * SECTOR_HEIGHT,
	}

	sector.center += sector.origin
	sector.name.origin += sector.origin

	sector.rectangle.x += sector.origin.x
	sector.rectangle.y += sector.origin.y

	for &route in sector.routes {
		route.start += sector.origin
		route.end += sector.origin
	}

	for &subsector_row in sector.subsectors {
		for &subsector in subsector_row {
			subsector.origin += sector.origin
			subsector.center += sector.origin

			subsector.rectangle.x += sector.origin.x
			subsector.rectangle.y += sector.origin.y

			subsector.name.origin += sector.origin

			for &system_row in subsector.systems {
				for &system in system_row {
					system.origin += subsector.origin

					system.index.origin += subsector.origin
					system.label.origin += subsector.origin
					system.name.origin += subsector.origin
				}
			}
		}
	}

	return nil
}

read_value :: proc(element: xml.Element) -> string {
	return len(element.value) > 0 ? element.value[0].(string) : ""
}
