/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:container/queue"
import "core:encoding/csv"
import "core:encoding/xml"
import "core:path/filepath"
import "core:slice"
import "core:strconv"
import "core:strings"

Reader :: csv.Reader

read_sectors :: proc() -> (sectors: [dynamic]Sector, err: Error) {
	assets := #load_directory("assets")

	for asset in assets {
		if asset.name == "M1105.xml" {
			document := xml.parse(asset.data, allocator = context.temp_allocator) or_return

			sector: Sector
			defer destroy_sector(sector)

			x, y: Text

			for element in document.elements {
				switch element.ident {
				case "Border":
					read_border(element, &sector) or_return
				case "DataFile":
					for file in assets {
						if file.name == read_value(element) && filepath.ext(file.name) == ".tab" {
							read_tab(&sector, Text(file.data)) or_return
						}
					}
				case "MetadataFile":
					for file in assets {
						if strings.to_lower(file.name) == strings.to_lower(read_value(element)) {
							read_xml(file.data, &sector, &x, &y) or_return
						}
					}
				case "Name":
					read_name(element, &sector) or_return
				case "Route":
					read_route(element, &sector) or_return
				case "Sector":
					if x != "" && y != "" {
						read_coords(x, y, &sector) or_return
						append(&sectors, sector) or_return
					}

					sector = new_sector() or_return
				case "Subsector":
					read_subsector(element, &sector) or_return
				case "X":
					x = read_value(element)
				case "Y":
					y = read_value(element)
				}
			}

			return
		}
	}

	return sectors, .Initialization_Failed
}

read_tab :: proc(sector: ^Sector, data: Text) -> Error {
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
		system.name = new_text(record[name_index] != "" ? record[name_index] : "????") or_return
		system.world = true
	}

	return nil
}

read_xml :: proc(data: []u8, sector: ^Sector, x, y: ^Text) -> Error {
	document := xml.parse(data, allocator = context.temp_allocator) or_return

	for element in document.elements {
		switch element.ident {
		case "Border":
			read_border(element, sector) or_return
		case "Name":
			read_name(element, sector) or_return
		case "Route":
			read_route(element, sector) or_return
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
	label: Text
	label_position: Text

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
		system.label = new_text(label) or_return
	}

	value := read_value(element)
	value, _ = strings.remove_all(value, "\n", context.temp_allocator)
	value, _ = strings.replace_all(value, "      ", " ", context.temp_allocator)
	value, _ = strings.replace_all(value, "  ", " ", context.temp_allocator)
	borders := strings.split(value, " ", context.temp_allocator) or_return

	xs := make([dynamic]f32, 0, context.temp_allocator)
	ys := make([dynamic]f32, 0, context.temp_allocator)

	for border in borders {
		offset := system_index(border) or_return

		append(&xs, offset.x) or_return
		append(&ys, offset.y) or_return

		system := get_system(sector, offset)
		system.allegiance = allegiance
		system.visited = true
	}

	min_x, max_x, _ := slice.min_max(xs[:])
	min_y, max_y, _ := slice.min_max(ys[:])

	min_x -= 1
	max_x += 1

	min_y -= 1
	max_y += 1

	flood: queue.Queue(^System)
	queue.init(&flood, allocator = context.temp_allocator) or_return

	for i := min_x; i < max_x; i += 1 {
		if system := get_system(sector, {i, min_y}); !system.visited {
			queue.push_back(&flood, system) or_return
		}
		if system := get_system(sector, {i, max_y}); !system.visited {
			queue.push_back(&flood, system) or_return
		}
	}

	for i := min_y; i < max_y; i += 1 {
		if system := get_system(sector, {min_x, i}); !system.visited {
			queue.push_back(&flood, system) or_return
		}
		if system := get_system(sector, {max_x, i}); !system.visited {
			queue.push_back(&flood, system) or_return
		}
	}

	for queue.len(flood) != 0 {
		current := queue.pop_front(&flood)
		current_hex := qoffset_to_cube(current.offset)

		for i in 0 ..= 5 {
			neighbor_offset := qoffset_from_cube(hex_neighbor(current_hex, i))
			neighbor_system := get_system(sector, neighbor_offset)

			if !neighbor_system.visited {
				neighbor_system.visited = true
				queue.push_back(&flood, neighbor_system) or_return
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
	if sector.name == "" {
		sector.name = new_text(read_value(element)) or_return
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

	route := new_route(allegiance, start, start_offset, end, end_offset, dashed)
	append(&sector.routes, route) or_return

	return nil
}

read_f32 :: proc(text: Text) -> (f32, Error) {
	value, value_ok := strconv.parse_f32(text)
	if !value_ok {
		return value, .Invalid_Float
	}

	return value, nil
}

read_int :: proc(text: Text) -> (int, Error) {
	value, value_ok := strconv.parse_int(text, 10)
	if !value_ok {
		return value, .Invalid_Int
	}

	return value, nil
}

read_subsector :: proc(element: xml.Element, sector: ^Sector) -> Error {
	index: u8

	for attribute in element.attribs {
		if attribute.key == "Index" {
			index = subsector_index(attribute.val)
		}
	}

	value := read_value(element)
	sector.subsectors[index / SECTOR_ROWS][index % SECTOR_ROWS].name = new_text(value) or_return

	return nil
}

read_coords :: proc(x_text, y_text: Text, sector: ^Sector) -> Error {
	x := read_f32(x_text) or_return
	y := read_f32(y_text) or_return

	M := sector.layout.orientation

	sector.layout.origin = {
		x * (M.f[0][0] * HEX_SIZE) * SECTOR_WIDTH,
		y * (M.f[1][1] * HEX_SIZE) * SECTOR_HEIGHT,
	}
	sector.center = grid_center(sector.layout, SECTOR_WIDTH, SECTOR_HEIGHT)

	for &row in sector.subsectors {
		for &subsector in row {
			subsector.layout.origin += sector.layout.origin
			subsector.center = grid_center(subsector.layout, SUBSECTOR_COLUMNS, SUBSECTOR_ROWS)
		}
	}

	return nil
}

read_value :: proc(element: xml.Element) -> Text {
	return len(element.value) > 0 ? element.value[0].(Text) : ""
}
