/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_sector :: proc(t: ^testing.T) {
	sector, _ := new_sector()
	defer destroy_sector(sector)

	testing.expect_value(t, sector.name, "")
	testing.expect_value(t, sector.layout.origin, Point{0, 0})
}
