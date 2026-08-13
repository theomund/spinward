/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_text :: proc(t: ^testing.T) {
	world, err := new_text("Flammarion")
	if err != nil {
		testing.fail(t)
	}
	defer destroy_text(world)

	testing.expect_value(t, world, "Flammarion")
}
