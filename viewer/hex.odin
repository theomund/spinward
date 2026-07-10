/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import rl "vendor:raylib"

Hex :: struct {
	name:   string,
	origin: rl.Vector2,
	color:  rl.Color,
}

new_hex :: proc(name: string, origin: rl.Vector2, color: rl.Color = rl.WHITE) -> Hex {
	return {name, origin, color}
}

draw_hex :: proc(hex: Hex) {
	rl.DrawPolyLines(hex.origin, 6, HEX_RADIUS, 0, hex.color)
}
