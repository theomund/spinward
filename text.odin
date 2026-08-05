/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:strings"
import rl "vendor:raylib"

new_text :: proc(value: string) -> (text: string, err: Error) {
	text = strings.clone(value) or_return

	return
}

destroy_text :: proc(text: string) -> Error {
	if text != "" {
		delete(text) or_return
	}

	return nil
}

draw_text :: proc(text: string, center: Point, size, spacing: f32, color: rl.Color) -> Error {
	if color.a != 0 {
		font := rl.GetFontDefault()

		text_clone := strings.clone_to_cstring(text, context.temp_allocator) or_return
		text_size := rl.MeasureTextEx(font, text_clone, size, spacing)

		rl.DrawTextEx(font, text_clone, center - text_size / 2, size, spacing, color)
	}

	return nil
}
