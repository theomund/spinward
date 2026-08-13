/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

import rl "vendor:raylib"

@(test)
test_fade_color :: proc(t: ^testing.T) {
	color := rl.RED
	start: f32 = 0.5
	end: f32 = 0.25

	faded := fade_color(color, 0.5, start, end)
	testing.expect_value(t, faded.a, 0)

	half_faded := fade_color(color, 0.375, start, end)
	testing.expect_value(t, half_faded.a, 127)

	unfaded := fade_color(color, 0.25, start, end)
	testing.expect_value(t, unfaded.a, 255)
}
