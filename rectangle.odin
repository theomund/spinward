/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

RECTANGLE_THICKNESS :: 2

Rectangle :: rl.Rectangle

new_rectangle :: proc(x, y, width, height: f32) -> Rectangle {
	return {x, y, width, height}
}

draw_rectangle :: proc(rect: Rectangle, color: Color) {
	rl.DrawRectangleLinesEx(rect, RECTANGLE_THICKNESS, color)
}
