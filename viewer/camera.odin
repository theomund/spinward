package viewer

import "core:math"
import rl "vendor:raylib"

new_camera :: proc() -> rl.Camera2D {
	return {zoom = 1.0}
}

zoom_camera :: proc(camera: ^rl.Camera2D) {
	if wheel := rl.GetMouseWheelMove(); wheel != 0.0 {
		position := rl.GetMousePosition()
		world := rl.GetScreenToWorld2D(position, camera^)

		camera.offset = position
		camera.target = world

		scale := 0.2 * wheel
		camera.zoom = clamp(math.exp(math.log(camera.zoom, math.E) + scale), 0.125, 64.0)
	}
}
