/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import "core:testing"

@(test)
test_flat_orientation :: proc(t: ^testing.T) {
	f := matrix[2, 2]f32{
		3.0 / 2.0, 0.0,
		math.SQRT_THREE / 2.0, math.SQRT_THREE,
	}

	b := matrix[2, 2]f32{
		2.0 / 3.0, -0.0,
		-1.0 / 3.0, math.SQRT_THREE / 3.0,
	}

	testing.expect_value(t, flat_orientation(), Orientation{f, b, 0.0})
}
