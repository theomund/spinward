/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

ROUTE_THICKNESS :: 4

Route :: struct {
	start: Offset,
	end:   Offset,
}

new_route :: proc(start, end: Offset) -> Route {
	return {start, end}
}

draw_route :: proc(layout: Layout, route: Route) {
	start := hex_to_pixel(layout, qoffset_to_cube(route.start))
	end := hex_to_pixel(layout, qoffset_to_cube(route.end))

	rl.DrawLineEx(start, end, ROUTE_THICKNESS, rl.GREEN)
}
