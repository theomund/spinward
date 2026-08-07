/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_subsector :: proc(t: ^testing.T) {
	origin := Point{0, 0}
	layout := flat_layout({0, 0})

	subsector := new_subsector(layout, origin)
	defer destroy_subsector(subsector)

	testing.expect_value(t, subsector.name, "")
}
