/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

Rectangle :: rl.Rectangle

new_rectangle :: proc(x, y, width, height: f32) -> Rectangle {
	return {x, y, width, height}
}

draw_rectangle :: proc(rect: Rectangle, color: rl.Color) {
	x := i32(rect.x)
	y := i32(rect.y)
	width := i32(rect.width)
	height := i32(rect.height)

	rl.DrawRectangleLines(x, y, width, height, color)
}
