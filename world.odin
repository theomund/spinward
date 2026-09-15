/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

WORLD_SIZE :: 12

draw_world :: proc(origin: Point, zoom: f32) {
	if color := fade_color(rl.BLUE, zoom, 0.05, 0.25); color.a != 0 {
		rl.DrawCircleV(origin, WORLD_SIZE, color)
	}
}
