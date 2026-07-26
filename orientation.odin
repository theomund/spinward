/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import "core:math/linalg"

Orientation :: struct {
	f:           matrix[2, 2]f32,
	b:           matrix[2, 2]f32,
	start_angle: f32,
}

new_orientation :: proc(f: matrix[2, 2]f32, start_angle: f32 = 0.0) -> Orientation {
	return {f, linalg.inverse(f), start_angle}
}

flat_orientation :: proc() -> Orientation {
	f := matrix[2, 2]f32{
		3.0 / 2.0, 0.0,
		math.SQRT_THREE / 2.0, math.SQRT_THREE,
	}

	return new_orientation(f)
}
