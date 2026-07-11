/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import rl "vendor:raylib"

run :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	defer rl.CloseWindow()

	sector := new_sector("Spinward Marches", {38, 6})

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)
		draw_sector(sector)
		rl.DrawFPS(16, WINDOW_HEIGHT - 32)

		rl.EndDrawing()
	}
}
