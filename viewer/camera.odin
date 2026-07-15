/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import "core:math"
import rl "vendor:raylib"

new_camera :: proc() -> rl.Camera2D {
	return {zoom = 1.0}
}

pan_camera :: proc(camera: ^rl.Camera2D) {
	if rl.IsMouseButtonDown(.RIGHT) {
		delta := rl.GetMouseDelta()
		delta *= -1.0 / camera.zoom

		camera.target += delta
	}
}

zoom_camera :: proc(camera: ^rl.Camera2D) {
	if wheel := rl.GetMouseWheelMove(); wheel != 0.0 {
		position := rl.GetMousePosition()
		world := rl.GetScreenToWorld2D(position, camera^)

		camera.offset = position
		camera.target = world

		scale := 0.2 * wheel
		value := math.exp(math.log(camera.zoom, math.E) + scale)

		camera.zoom = clamp(value, 0.125, 64.0)
	}
}
