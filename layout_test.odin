/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_layout :: proc(t: ^testing.T) {
	hex := new_hex(3, 4, -7)
	layout := new_layout(flat_orientation(), new_point(10.0, 15.0), new_point(35.0, 71.0))

	testing.expect_value(t, pixel_to_hex_rounded(layout, hex_to_pixel(layout, hex)), hex)
}
