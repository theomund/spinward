/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:encoding/csv"
import "core:encoding/xml"
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
			reader := new_reader()
			defer destroy_reader(&reader)

			csv.reader_init_with_string(&reader, string(asset.data))

			for record, _, err in csv.iterator_next(&reader) {
				if err != nil {
					return sector, err
				}

				if record[1] == "SS" {
					continue
				}

				index := record[1][0] - 'A'
				subsector := &sector.subsectors[index / SECTOR_ROWS][index % SECTOR_ROWS]

				for &row in subsector.systems {
					for &system in row {
						if record[2] == string(system.index) {
							system.name = strings.clone_to_cstring(record[3])
							system.allegiance = new_allegiance(record[9])
						}
					}
				}
			}
		case ".xml":
			document := xml.parse(asset.data) or_return
			defer xml.destroy(document)

			for &element in document.elements {
				switch element.ident {
				case "Name":
					if element.attribs == nil {
						sector.name = value_to_cstring(element.value) or_return
					}
				case "Subsector":
					str := value_to_cstring(element.value) or_return
					index := int(element.attribs[0].val[0]) - 'A'

					sector.subsectors[index / SECTOR_ROWS][index % SECTOR_ROWS].name = str
				}
			}
		}
	}

	return
}

value_to_cstring :: proc(value: [dynamic]xml.Value) -> (str: cstring, err: Error) {
	str = strings.clone_to_cstring(value[0].(string)) or_return

	return
}
