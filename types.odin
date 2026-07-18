/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:os"
import rl "vendor:raylib"

Error :: union {
	os.Error,
	Spinward_Error,
}

Hex :: rl.Vector3

Layout :: struct {
	orientation:  Orientation,
	origin, size: Point,
}

Offset :: rl.Vector2

Orientation :: struct {
	f:           matrix[2, 2]f32,
	b:           matrix[2, 2]f32,
	start_angle: f32,
}

Point :: rl.Vector2

Sector :: struct {
	name:   string,
	hexes:  map[string]Hex,
	layout: Layout,
}

Spinward_Error :: enum {
	Initialization_Failed,
}
