/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

RECTANGLE_THICKNESS :: 2

Rectangle :: rl.Rectangle

new_rectangle :: proc(layout: Layout, width: f32, height: f32) -> (rect: Rectangle, err: Error) {
	h1 := qoffset_to_cube({0, 0}) or_return
	p1 := hex_to_pixel(layout, h1)

	h2 := qoffset_to_cube({width - 1, height - 1}) or_return
	p2 := hex_to_pixel(layout, h2)

	M := layout.orientation

	rect = {
		p1.x - HEX_SIZE / (4.0 / 3.0),
		p1.y - HEX_SIZE * M.f[0][1],
		p2.x - p1.x + HEX_SIZE * M.f[0][0],
		p2.y - p1.y + HEX_SIZE * M.f[0][1],
	}

	return
}

draw_rectangle :: proc(rect: Rectangle, color: Color) {
	rl.DrawRectangleLinesEx(rect, RECTANGLE_THICKNESS, color)
}
