/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_system :: proc(t: ^testing.T) {
	hex := new_hex(0, 0, 0)
	system := new_system("Flammarion", .Third_Imperium, hex, "0101")

	testing.expect_value(t, system.name, "Flammarion")
	testing.expect_value(t, system.allegiance, Allegiance.Third_Imperium)
	testing.expect_value(t, system.hex, hex)
	testing.expect_value(t, system.index, "0101")
}
