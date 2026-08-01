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

read_sector :: proc() -> (sector: Sector, err: Error) {
	assets := #load_directory("assets")

	sector = new_sector()

	for asset in assets {
		switch filepath.ext(asset.name) {
		case ".tab":
			read_tab(&sector, string(asset.data))
		case ".xml":
			read_xml(&sector, string(asset.data))
		}
	}

	return
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

		system.name = strings.clone_to_cstring(record[3])
		system.allegiance = new_allegiance(record[9])
	}

	return nil
}

read_xml :: proc(sector: ^Sector, data: string) -> Error {
	document := xml.parse(data) or_return
	defer xml.destroy(document)

	for &element in document.elements {
		switch element.ident {
		case "Border":
			allegiance: Allegiance

			for attribute in element.attribs {
				if attribute.key == "Allegiance" {
					allegiance = new_allegiance(attribute.val)
				}
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
		case "Name":
			if element.attribs == nil {
				sector.name = value_to_cstring(element.value) or_return
			}
		case "Subsector":
			str := value_to_cstring(element.value) or_return
			index := subsector_index(element.attribs[0].val)

			sector.subsectors[index / SECTOR_ROWS][index % SECTOR_ROWS].name = str
		}
	}

	free_all(context.temp_allocator) or_return

	return nil
}

value_to_cstring :: proc(value: [dynamic]xml.Value) -> (str: cstring, err: Error) {
	str = strings.clone_to_cstring(value[0].(string)) or_return

	return
}
