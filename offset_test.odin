/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_qoffset_from_cube :: proc(t: ^testing.T) {
	testing.expect_value(t, qoffset_from_cube(new_hex(-2, 3, -1)), Offset{-2, 2})
	testing.expect_value(t, qoffset_from_cube(new_hex(-1, -1, 2)), Offset{-1, -2})
}

@(test)
test_qoffset_to_cube :: proc(t: ^testing.T) {
	testing.expect_value(t, qoffset_to_cube(Offset{-2, 2}), new_hex(-2, 3, -1))
	testing.expect_value(t, qoffset_to_cube(Offset{-1, -2}), new_hex(-1, -1, 2))
}
