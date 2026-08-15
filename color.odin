/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import rl "vendor:raylib"

Color :: rl.Color

fade_color :: proc(color: Color, zoom, start, end: f32) -> Color {
	faded := color
	faded.a = u8(math.clamp((start - zoom) / (start - end), 0, 1) * 255)

	return faded
}
