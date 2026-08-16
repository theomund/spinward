/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:math"
import rl "vendor:raylib"

ROUTE_THICKNESS :: 4


Route :: struct {
	allegiance:   Allegiance,
	start:        Offset,
	start_offset: Offset,
	end:          Offset,
	end_offset:   Offset,
	dashed:       bool,
}

new_route :: proc(
	allegiance: Allegiance,
	start, start_offset, end, end_offset: Offset,
	dashed: bool,
) -> Route {
	return {allegiance, start, start_offset, end, end_offset, dashed}
}

draw_route :: proc(layout: Layout, route: Route) {
	start_layout := layout
	start_layout.origin += {
		route.start_offset.x * (1.5 * HEX_SIZE) * SECTOR_WIDTH,
		route.start_offset.y * (math.SQRT_THREE * HEX_SIZE) * SECTOR_HEIGHT,
	}

	start := hex_to_pixel(start_layout, qoffset_to_cube(route.start))

	end_layout := layout
	end_layout.origin += {
		route.end_offset.x * (1.5 * HEX_SIZE) * SECTOR_WIDTH,
		route.end_offset.y * (math.SQRT_THREE * HEX_SIZE) * SECTOR_HEIGHT,
	}

	end := hex_to_pixel(end_layout, qoffset_to_cube(route.end))

	color := route.allegiance == .Unaligned ? rl.GREEN : allegiances[route.allegiance].color

	if route.dashed {
		rl.DrawLineDashed(start, end, 8, 4, color)
	} else {
		rl.DrawLineV(start, end, color)
	}
}
