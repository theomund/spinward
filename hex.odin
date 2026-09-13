/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

HEX_SIZE :: 64
HALF_HEX :: HEX_SIZE / 2

Hex :: rl.Vector3

@(rodata)
hex_directions := [6]Hex {
	Hex{1, 0, -1},
	Hex{1, -1, 0},
	Hex{0, -1, 1},
	Hex{-1, 0, 1},
	Hex{-1, 1, 0},
	Hex{0, 1, -1},
}

new_hex :: proc(q, r, s: f32) -> (Hex, Error) {
	if math.round(q + r + s) != 0 {
		return {q, r, s}, .Invalid_Hex
	}

	return {q, r, s}, nil
}

hex_direction :: proc(direction: int) -> Hex {
	assert(0 <= direction && direction < 6)

	return hex_directions[direction]
}

hex_lerp :: proc(a, b: Hex, t: f32) -> Hex {
	return math.lerp(a, b, t)
}

hex_neighbor :: proc(hex: Hex, direction: int) -> Hex {
	return hex + hex_direction(direction)
}

hex_to_pixel :: proc(layout: Layout, hex: Hex) -> Point {
	M := layout.orientation
	size := layout.size
	origin := layout.origin

	x := (M.f[0, 0] * hex.x + M.f[0, 1] * hex.y) * size.x
	y := (M.f[1, 0] * hex.x + M.f[1, 1] * hex.y) * size.y

	return Point{x + origin.x, y + origin.y}
}

hex_round :: proc(hex: Hex) -> (Hex, Error) {
	q := math.round(hex.x)
	r := math.round(hex.y)
	s := math.round(hex.z)

	q_diff := math.abs(q - hex.x)
	r_diff := math.abs(r - hex.y)
	s_diff := math.abs(s - hex.z)

	if q_diff > r_diff && q_diff > s_diff {
		q = -r - s
	} else if r_diff > s_diff {
		r = -q - s
	} else {
		s = -q - r
	}

	return new_hex(q, r, s)
}

draw_hex :: proc(origin: Point, color: Color, fill := false) {
	if color.a != 0 {
		if fill {
			rl.DrawPoly(origin, 6, HEX_SIZE, 0, color)
		} else {
			rl.DrawPolyLines(origin, 6, HEX_SIZE, 0, color)
		}
	}
}
