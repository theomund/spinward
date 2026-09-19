/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"

Orientation :: struct {
	f, b: matrix[2, 2]f32,
}

M :: Orientation {
	f = matrix[2, 2]f32{
		1.5, 0.0,
		math.SQRT_THREE / 2.0, math.SQRT_THREE,
	},
	b = matrix[2, 2]f32{
		2.0 / 3.0, -0.0,
		-1.0 / 3.0, math.SQRT_THREE / 3.0,
	},
}
