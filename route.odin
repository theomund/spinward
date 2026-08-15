/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

ROUTE_THICKNESS :: 4

Route :: struct {
	allegiance: Allegiance,
	start:      Offset,
	end:        Offset,
}

new_route :: proc(allegiance: Allegiance, start, end: Offset) -> Route {
	return {allegiance, start, end}
}

draw_route :: proc(layout: Layout, route: Route) {
	start := hex_to_pixel(layout, qoffset_to_cube(route.start))
	end := hex_to_pixel(layout, qoffset_to_cube(route.end))
	color := route.allegiance == .Unaligned ? rl.GREEN : allegiances[route.allegiance].color

	rl.DrawLineEx(start, end, ROUTE_THICKNESS, color)
}
