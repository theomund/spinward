/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import rl "vendor:raylib"

Camera :: rl.Camera2D

new_camera :: proc() -> Camera {
	return {zoom = 1.0}
}

poll_camera :: proc(camera: ^Camera) {
	if rl.IsMouseButtonDown(.RIGHT) {
		pan_camera(camera, rl.GetMouseDelta())
	}

	if wheel := rl.GetMouseWheelMove(); wheel != 0.0 {
		zoom_camera(camera, wheel, rl.GetMousePosition())
	}
}

pan_camera :: proc(camera: ^Camera, delta: Point) {
	camera.target += delta * -1.0 / camera.zoom
}

zoom_camera :: proc(camera: ^Camera, wheel: f32, position: Point) {
	camera^ = {
		offset = position,
		target = rl.GetScreenToWorld2D(position, camera^),
		zoom   = clamp(math.exp(math.log(camera.zoom, math.E) + 0.2 * wheel), 0.125, 64.0),
	}
}

fade :: proc(zoom, start, end: f32) -> u8 {
	return u8(math.clamp((start - zoom) / (start - end), 0, 1) * 255)
}
