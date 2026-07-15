/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"
import rl "vendor:raylib"

@(test)
test_new_camera :: proc(t: ^testing.T) {
	testing.expect_value(t, new_camera(), rl.Camera2D{zoom = 1.0})
}

@(test)
test_pan_camera :: proc(t: ^testing.T) {
	camera := new_camera()

	pan_camera(&camera, {1.0, 2.0})

	testing.expect_value(t, camera.target, rl.Vector2{-1.0, -2.0})
}
