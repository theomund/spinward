/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import rl "vendor:raylib"

new_camera :: proc() -> rl.Camera2D {
	return {zoom = 1.0}
}

poll_camera :: proc(camera: ^rl.Camera2D) {
	if rl.IsMouseButtonDown(.RIGHT) {
		pan_camera(camera, rl.GetMouseDelta())
	}

	if wheel := rl.GetMouseWheelMove(); wheel != 0.0 {
		zoom_camera(camera, wheel, rl.GetMousePosition())
	}
}

pan_camera :: proc(camera: ^rl.Camera2D, delta: rl.Vector2) {
	camera.target += delta * -1.0 / camera.zoom
}

zoom_camera :: proc(camera: ^rl.Camera2D, wheel: f32, position: rl.Vector2) {
	camera^ = {
		offset = position,
		target = rl.GetScreenToWorld2D(position, camera^),
		zoom   = clamp(math.exp(math.log(camera.zoom, math.E) + 0.2 * wheel), 0.125, 64.0),
	}
}
