/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"

Orientation :: struct {
	f0:          f64,
	f1:          f64,
	f2:          f64,
	f3:          f64,
	b0:          f64,
	b1:          f64,
	b2:          f64,
	b3:          f64,
	start_angle: f64,
}

new_orientation :: proc(f0, f1, f2, f3, b0, b1, b2, b3, start_angle: f64) -> Orientation {
	return {f0, f1, f2, f3, b0, b1, b2, b3, start_angle}
}

flat_orientation :: proc() -> Orientation {
	return {
		3.0 / 2.0,
		0.0,
		math.SQRT_THREE / 2.0,
		math.SQRT_THREE,
		2.0 / 3.0,
		0.0,
		-1.0 / 3.0,
		math.SQRT_THREE / 3.0,
		0.0,
	}
}
