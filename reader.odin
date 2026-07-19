/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:encoding/csv"
import "core:os"
import "core:strings"

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

read_sector :: proc(reader: ^Reader, path: string, systems: map[string]System) -> Error {
	data := os.read_entire_file(path, context.allocator) or_return
	defer delete(data)

	csv.reader_init_with_string(reader, string(data))

	for record, _, err in csv.iterator_next(reader) {
		if err != nil {
			return err
		}

		if system := &systems[record[2]]; system != nil {
			system.allegiance = strings.clone_to_cstring(record[9])
			system.name = strings.clone_to_cstring(record[3])
		}
	}

	return nil
}
