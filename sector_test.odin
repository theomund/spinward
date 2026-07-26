/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_sector :: proc(t: ^testing.T) {
	name: cstring = "Spinward Marches"

	sector := new_sector(name)
	defer delete_sector(sector)

	testing.expect_value(t, sector.name, name)
	testing.expect_value(t, sector.layout.origin, Point{0, 0})
	testing.expect_value(t, sector.layout.size, Point{HEX_SIZE, HEX_SIZE})
}
