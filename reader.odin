/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:encoding/csv"
import "core:encoding/xml"
import "core:math"
import "core:path/filepath"
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

read_sectors :: proc() -> (sectors: map[string]Sector, err: Error) {
	assets := #load_directory("assets")

	for asset in assets {
		name := filepath.stem(asset.name)

		if name not_in sectors {
			sectors[name] = new_sector()
		}

		data := string(asset.data)

		switch filepath.ext(asset.name) {
		case ".tab":
			read_tab(&sectors[name], data) or_return
		case ".xml":
			read_xml(&sectors[name], data) or_return
		}
	}

	return sectors, nil
}

read_tab :: proc(sector: ^Sector, data: string) -> Error {
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

		subsector := &sector.subsectors[y / SUBSECTOR_ROWS][x / SUBSECTOR_COLUMNS]
		system := &subsector.systems[y % SUBSECTOR_ROWS][x % SUBSECTOR_COLUMNS]

		system.allegiance = new_allegiance(record[9])
		system.name = record[3] != "" ? strings.clone_to_cstring(record[3]) : "????"
		system.world = true
	}

	return nil
}

read_xml :: proc(sector: ^Sector, data: string) -> Error {
	document := xml.parse(data) or_return
	defer xml.destroy(document)

	for &element in document.elements {
		switch element.ident {
		case "Border":
			read_border(element, sector) or_return
		case "Name":
			read_name(element, sector) or_return
		case "Subsector":
			read_subsector(element, sector) or_return
		case "X":
			read_x(element, sector) or_return
		case "Y":
			read_y(element, sector) or_return
		}
	}

	free_all(context.temp_allocator) or_return

	return nil
}

read_border :: proc(element: xml.Element, sector: ^Sector) -> Error {
	allegiance: Allegiance
	label: cstring
	label_position: string

	for attribute in element.attribs {
		switch attribute.key {
		case "Allegiance":
			allegiance = new_allegiance(attribute.val)
		case "Label":
			label = strings.clone_to_cstring(attribute.val) or_return
		case "LabelPosition":
			label_position = attribute.val
		}
	}

	if label == "" {
		label = from_allegiance(allegiance)
	}

	if label_position != "" {
		x, y := system_index(label_position) or_return

		subsector := &sector.subsectors[y / SUBSECTOR_ROWS][x / SUBSECTOR_COLUMNS]
		system := &subsector.systems[y % SUBSECTOR_ROWS][x % SUBSECTOR_COLUMNS]
		system.label = label
	}

	value := element.value[0].(string)
	newlines, _ := strings.remove_all(value, "\n", context.temp_allocator)
	spaces, _ := strings.replace_all(newlines, "      ", " ", context.temp_allocator)
	borders := strings.split(spaces, " ", context.temp_allocator) or_return

	for border in borders {
		x, y := system_index(border) or_return

		x = math.clamp(x, 0, 31)
		y = math.clamp(y, 0, 39)

		subsector := &sector.subsectors[y / SUBSECTOR_ROWS][x / SUBSECTOR_COLUMNS]
		system := &subsector.systems[y % SUBSECTOR_ROWS][x % SUBSECTOR_COLUMNS]
		system.allegiance = allegiance
	}

	return nil
}

read_name :: proc(element: xml.Element, sector: ^Sector) -> Error {
	if element.attribs == nil {
		sector.name = value_to_cstring(element.value) or_return
	}

	return nil
}

read_subsector :: proc(element: xml.Element, sector: ^Sector) -> Error {
	index := subsector_index(element.attribs[0].val)

	sector.subsectors[index / SECTOR_ROWS][index % SECTOR_ROWS].name = value_to_cstring(
		element.value,
	) or_return

	return nil
}

read_x :: proc(element: xml.Element, sector: ^Sector) -> Error {
	x, ok := strconv.parse_f32(element.value[0].(string))
	if !ok {
		return .Invalid_Index
	}

	sector.layout.origin.x = x * (1.5 * HEX_SIZE) * SECTOR_WIDTH
	sector.center = grid_center(sector.layout, SECTOR_WIDTH, SECTOR_HEIGHT)

	for &row in sector.subsectors {
		for &subsector in row {
			subsector.layout.origin.x += sector.layout.origin.x
			subsector.center = grid_center(subsector.layout, SUBSECTOR_COLUMNS, SUBSECTOR_ROWS)
		}
	}

	return nil
}

read_y :: proc(element: xml.Element, sector: ^Sector) -> Error {
	y, ok := strconv.parse_f32(element.value[0].(string))
	if !ok {
		return .Invalid_Index
	}

	sector.layout.origin.y = y * (math.SQRT_THREE * HEX_SIZE) * SECTOR_HEIGHT
	sector.center = grid_center(sector.layout, SECTOR_WIDTH, SECTOR_HEIGHT)

	for &row in sector.subsectors {
		for &subsector in row {
			subsector.layout.origin.y += sector.layout.origin.y
			subsector.center = grid_center(subsector.layout, SUBSECTOR_COLUMNS, SUBSECTOR_ROWS)
		}
	}

	return nil
}

value_to_cstring :: proc(value: [dynamic]xml.Value) -> (str: cstring, err: Error) {
	str = strings.clone_to_cstring(value[0].(string)) or_return

	return
}
