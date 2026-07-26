/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_subsector :: proc(t: ^testing.T) {
	name: cstring = "Core"
	layout := flat_layout({0, 0})

	subsector := new_subsector(name, layout, {0, 0})
	defer delete_subsector(subsector)

	testing.expect_value(t, subsector.name, name)
}
