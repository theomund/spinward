/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:container/queue"
import "core:encoding/csv"
import "core:encoding/xml"
import "core:math"
import "core:path/filepath"
import "core:slice"
import "core:strconv"
import "core:strings"

Reader :: csv.Reader

new_reader :: proc() -> Reader {
	return {
		comma = '\t',
		comment = '#',
		fields_per_record = -1,
		reuse_record = true,
		reuse_record_buffer = true,
	}
}

destroy_reader :: proc(reader: ^Reader) {
	csv.reader_destroy(reader)
}

read_sectors :: proc() -> (sectors: map[Text]Sector, err: Error) {
	assets := #load_directory("assets")

	for asset in assets {
		name := filepath.stem(asset.name)

		if name not_in sectors {
			sectors[name] = new_sector()
		}

		data := Text(asset.data)

		switch filepath.ext(asset.name) {
		case ".tab":
			read_tab(&sectors[name], data) or_return
		case ".xml":
			read_xml(&sectors[name], data) or_return
		}
	}

	return sectors, nil
}

read_tab :: proc(sector: ^Sector, data: Text) -> Error {
	reader := new_reader()
	defer destroy_reader(&reader)

	csv.reader_init_with_string(&reader, data)

	for record, _, err in csv.iterator_next(&reader) {
		if err != nil {
			return err
		}

		if record[1] == "SS" {
			continue
		}

		x, y := system_index(record[2]) or_return

		system := get_system(sector, x, y)

		system.allegiance = new_allegiance(record[9])
		system.name = new_text(record[3] != "" ? record[3] : "????") or_return
		system.world = true
	}

	return nil
}

read_xml :: proc(sector: ^Sector, data: Text) -> Error {
	document := xml.parse(data) or_return
	defer xml.destroy(document)

	x, y: Text

	for &element in document.elements {
		switch element.ident {
		case "Border":
			read_border(element, sector) or_return
		case "Name":
			if sector.name == "" {
				read_name(element, sector) or_return
			}
		case "Route":
			read_route(element, sector) or_return
		case "Subsector":
			read_subsector(element, sector) or_return
		case "X":
			x = read_value(element)
		case "Y":
			y = read_value(element)
		}
	}

	read_coords(x, y, sector) or_return

	free_all(context.temp_allocator) or_return

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
			label = new_text(attribute.val) or_return
		case "LabelPosition":
			label_position = attribute.val
		}
	}

	if label == "" {
		label = new_text(allegiances[allegiance].label) or_return
	}

	if label_position != "" {
		x, y := system_index(label_position) or_return

		system := get_system(sector, x, y)
		system.label = label
	} else {
		destroy_text(label)
	}

	value := read_value(element)
	newlines, _ := strings.remove_all(value, "\n", context.temp_allocator)
	spaces, _ := strings.replace_all(newlines, "      ", " ", context.temp_allocator)
	borders := strings.split(spaces, " ", context.temp_allocator) or_return

	xs: [dynamic]int
	defer delete(xs)

	ys: [dynamic]int
	defer delete(ys)

	for border in borders {
		x, y := system_index(border) or_return

		append(&xs, x) or_return
		append(&ys, y) or_return

		system := get_system(sector, x, y)
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
	queue.init(&flood) or_return
	defer queue.destroy(&flood)

	for i := min_x; i < max_x; i += 1 {
		if system := get_system(sector, i, min_y); !system.visited {
			queue.push_back(&flood, system) or_return
		}
	}

	for i := min_y; i < max_y; i += 1 {
		if system := get_system(sector, max_x, i); !system.visited {
			queue.push_back(&flood, system) or_return
		}
	}

	for i := max_x; i > min_x; i -= 1 {
		if system := get_system(sector, i, max_y); !system.visited {
			queue.push_back(&flood, system) or_return
		}
	}

	for i := max_y; i > min_y; i -= 1 {
		if system := get_system(sector, min_x, i); !system.visited {
			queue.push_back(&flood, system) or_return
		}
	}

	for queue.len(flood) != 0 {
		current := queue.pop_front(&flood)

		cx, cy := system_index(current.index) or_return
		current_hex := qoffset_to_cube({f32(cx), f32(cy)})

		for i in 0 ..= 5 {
			neighbor_hex := hex_neighbor(current_hex, i)
			neighbor_offset := qoffset_from_cube(neighbor_hex)

			nx := int(neighbor_offset.x)
			ny := int(neighbor_offset.y)
			neighbor_system := get_system(sector, nx, ny)

			if !neighbor_system.visited {
				neighbor_system.visited = true
				queue.push_back(&flood, neighbor_system)
			}
		}
	}

	for y := 0; y < SECTOR_HEIGHT; y += 1 {
		for x := 0; x < SECTOR_WIDTH; x += 1 {
			if c := get_system(sector, x, y); !c.visited {
				c.allegiance = allegiance
			}
		}
	}

	for y := 0; y < SECTOR_HEIGHT; y += 1 {
		for x := 0; x < SECTOR_WIDTH; x += 1 {
			if c := get_system(sector, x, y); c.visited {
				c.visited = false
			}
		}
	}

	return nil
}

read_name :: proc(element: xml.Element, sector: ^Sector) -> Error {
	if element.attribs == nil {
		value := read_value(element)
		sector.name = new_text(value) or_return
	} else {
		for attribute in element.attribs {
			if attribute.key == "Lang" {
				return .Invalid_Name
			}
		}

		value := read_value(element)
		sector.name = new_text(value) or_return
	}

	return nil
}

read_route :: proc(element: xml.Element, sector: ^Sector) -> Error {
	allegiance: Allegiance
	start, end: Offset

	for attribute in element.attribs {
		switch attribute.key {
		case "Allegiance":
			allegiance = new_allegiance(attribute.val)
		case "Start":
			x, y := system_index(attribute.val) or_return
			start = new_offset(f32(x), f32(y))
		case "End":
			x, y := system_index(attribute.val) or_return
			end = new_offset(f32(x), f32(y))
		}
	}

	route := new_route(allegiance, start, end)
	append(&sector.routes, route) or_return

	return nil
}

read_subsector :: proc(element: xml.Element, sector: ^Sector) -> Error {
	index := subsector_index(element.attribs[0].val)

	value := read_value(element)
	sector.subsectors[index / SECTOR_ROWS][index % SECTOR_ROWS].name = new_text(value) or_return

	return nil
}

read_coords :: proc(x_text, y_text: Text, sector: ^Sector) -> Error {
	x, x_ok := strconv.parse_f32(x_text)
	if !x_ok {
		return .Invalid_Index
	}

	y, y_ok := strconv.parse_f32(y_text)
	if !y_ok {
		return .Invalid_Index
	}

	sector.layout.origin = {
		x * (1.5 * HEX_SIZE) * SECTOR_WIDTH,
		y * (math.SQRT_THREE * HEX_SIZE) * SECTOR_HEIGHT,
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
	return element.value[0].(Text)
}
