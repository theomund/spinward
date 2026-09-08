/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

RECTANGLE_THICKNESS :: 2

Rectangle :: rl.Rectangle

draw_rectangle :: proc(rect: Rectangle, color: Color) {
	rl.DrawRectangleLinesEx(rect, RECTANGLE_THICKNESS, color)
}
