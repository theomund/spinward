/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080
WINDOW_TITLE :: "Spinward"

new_window :: proc() -> Error {
	rl.SetConfigFlags({.MSAA_4X_HINT})

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)

	return !rl.IsWindowReady() ? .Initialization_Failed : nil
}

destroy_window :: proc() {
	rl.CloseWindow()
}

render :: proc(sector: Sector, camera: ^Camera) {
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)
		rl.DrawFPS(16, WINDOW_HEIGHT - 32)

		poll_camera(camera)

		rl.BeginMode2D(camera^)
		draw_sector(sector, camera^)
		rl.EndMode2D()

		rl.EndDrawing()
	}
}
