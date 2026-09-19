/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:strings"
import rl "vendor:raylib"

Text :: struct {
	content: cstring,
	origin:  Point,
	size:    f32,
	spacing: f32,
	color:   Color,
}

new_text :: proc(
	value: string,
	origin := Point{0, 0},
	size := f32(FONT_SIZE),
	spacing := f32(FONT_SPACING),
	color := rl.WHITE,
) -> (
	text: Text,
	err: Error,
) {
	content: cstring

	if value != "" {
		content = strings.clone_to_cstring(value) or_return
	}

	text = {
		content,
		origin - rl.MeasureTextEx(rl.GetFontDefault(), content, size, spacing) / 2,
		size,
		spacing,
		color,
	}

	return
}

destroy_text :: proc(text: Text) -> Error {
	if text.content != "" {
		delete(text.content) or_return
	}

	return nil
}

draw_text :: proc(text: Text, zoom, start, end: f32) {
	if color := fade_color(text.color, zoom, start, end); color.a != 0 {
		rl.DrawTextEx(
			rl.GetFontDefault(),
			text.content,
			text.origin,
			text.size,
			text.spacing,
			color,
		)
	}
}
