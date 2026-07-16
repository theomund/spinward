/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

Error :: enum {
	Initialization_Failed,
}

Hex :: rl.Vector3

Layout :: struct {
	orientation:  Orientation,
	origin, size: Point,
}

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
