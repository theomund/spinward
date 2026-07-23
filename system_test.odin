/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_system :: proc(t: ^testing.T) {
	hex := new_hex(1, 1, -2)

	testing.expect_value(t, new_system(hex), System{hex = hex})
}
