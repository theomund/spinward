/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_hex :: proc(t: ^testing.T) {
	a, _ := new_hex(1, 1, -2)

	testing.expect_value(t, a, Hex{1, 1, -2})
}

@(test)
test_hex_round :: proc(t: ^testing.T) {
	a, _ := new_hex(1.2, 0.9, -2.1)
	b, _ := hex_round(a)
	c, _ := new_hex(1, 1, -2)

	testing.expect_value(t, b, c)
}
