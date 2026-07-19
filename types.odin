/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:encoding/csv"
import "core:os"
import rl "vendor:raylib"

Error :: union {
	csv.Error,
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

Reader :: csv.Reader

Sector :: struct {
	name:    cstring,
	systems: map[string]System,
	layout:  Layout,
}

System :: struct {
	name: cstring,
	hex:  Hex,
}

Spinward_Error :: enum {
	Initialization_Failed,
}
