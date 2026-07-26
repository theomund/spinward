/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

Layout :: struct {
	orientation:  Orientation,
	origin, size: Point,
}

new_layout :: proc(
	orientation: Orientation,
	origin: Point,
	size: Point = {HEX_SIZE, HEX_SIZE},
) -> Layout {
	return {orientation, origin, size}
}

flat_layout :: proc(origin: Point) -> Layout {
	return new_layout(flat_orientation(), origin)
}
