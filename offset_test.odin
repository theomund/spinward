/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_qoffset_from_cube :: proc(t: ^testing.T) {
	a, _ := new_hex(-2, 3, -1)
	b, _ := new_hex(-1, -1, 2)

	testing.expect_value(t, qoffset_from_cube(a), Offset{-2, 2})
	testing.expect_value(t, qoffset_from_cube(b), Offset{-1, -2})
}

@(test)
test_qoffset_to_cube :: proc(t: ^testing.T) {
	a, _ := new_hex(-2, 3, -1)
	b, _ := new_hex(-1, -1, 2)
	c, _ := qoffset_to_cube(Offset{-2, 2})
	d, _ := qoffset_to_cube(Offset{-1, -2})

	testing.expect_value(t, c, a)
	testing.expect_value(t, d, b)
}
