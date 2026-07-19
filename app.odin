/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

run :: proc() -> Error {
	rl.SetConfigFlags({.MSAA_4X_HINT})

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	defer rl.CloseWindow()

	if !rl.IsWindowReady() {
		return .Initialization_Failed
	}

	camera := new_camera()

	sector := new_sector("assets/Spinward Marches.tab") or_return
	defer delete_sector(sector)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)
		rl.DrawFPS(16, WINDOW_HEIGHT - 32)

		poll_camera(&camera)

		rl.BeginMode2D(camera)
		draw_sector(sector, camera)
		rl.EndMode2D()

		rl.EndDrawing()
	}

	return nil
}
