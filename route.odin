/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

ROUTE_THICKNESS :: 4

Route :: struct {
	color:  Color,
	dashed: bool,
	end:    Offset,
	start:  Offset,
}

new_route :: proc(
	allegiance: Allegiance,
	dashed: bool,
	end_offset: Offset,
	end: Offset,
	origin: Point,
	start_offset: Offset,
	start: Offset,
) -> (
	route: Route,
	err: Error,
) {
	start_origin := origin
	start_origin += {
		start_offset.x * (M.f[0][0] * HEX_SIZE) * SECTOR_WIDTH,
		start_offset.y * (M.f[1][1] * HEX_SIZE) * SECTOR_HEIGHT,
	}

	start_hex := qoffset_to_cube(start) or_return

	end_origin := origin
	end_origin += {
		end_offset.x * (M.f[0][0] * HEX_SIZE) * SECTOR_WIDTH,
		end_offset.y * (M.f[1][1] * HEX_SIZE) * SECTOR_HEIGHT,
	}

	end_hex := qoffset_to_cube(end) or_return

	route = {
		allegiance == .Unaligned ? rl.GREEN : allegiances[allegiance].color,
		dashed,
		hex_to_pixel(end_origin, end_hex),
		hex_to_pixel(start_origin, start_hex),
	}

	return
}

draw_route :: proc(route: Route, zoom: f32) {
	if color := fade_color(route.color, zoom, 0.05, 0.25); color.a != 0 {
		if route.dashed {
			rl.DrawLineDashed(route.start, route.end, 8, 4, color)
		} else {
			rl.DrawLineV(route.start, route.end, color)
		}
	}
}
