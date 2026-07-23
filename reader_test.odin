/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_reader :: proc(t: ^testing.T) {
    reader := new_reader()
    defer destroy_reader(&reader)

	testing.expect_value(t, reader.comma, '\t')
    testing.expect_value(t, reader.comment, '#')
    testing.expect_value(t, reader.fields_per_record, -1)
    testing.expect(t, reader.reuse_record_buffer)
    testing.expect(t, reader.reuse_record)
}
