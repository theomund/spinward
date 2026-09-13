/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

check_visibility :: proc(sectors: []Sector, camera: Camera) -> Error {
	p1 := rl.GetScreenToWorld2D({0, 0}, camera)
	p2 := rl.GetScreenToWorld2D({WINDOW_WIDTH, WINDOW_HEIGHT}, camera)

	screen := Rectangle{p1.x, p1.y, p2.x - p1.x, p2.y - p1.y}

	for &sector in sectors {
		sector.visible = rl.CheckCollisionRecs(screen, sector.rectangle)

		for &row in sector.subsectors {
			for &subsector in row {
				subsector.visible = rl.CheckCollisionRecs(screen, subsector.rectangle)
			}
		}
	}

	return nil
}
