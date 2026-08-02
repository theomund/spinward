/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

draw_text :: proc(text: cstring, center: Point, size, spacing: f32, color: rl.Color) {
	if color.a != 0 {
		font := rl.GetFontDefault()
		text_size := rl.MeasureTextEx(font, text, size, spacing)

		rl.DrawTextEx(font, text, center - text_size / 2, size, spacing, color)
	}
}
