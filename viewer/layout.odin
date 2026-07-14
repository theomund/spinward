/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

Layout :: struct {
	orientation: Orientation,
	origin:      Point,
	size:        Point,
}

new_layout :: proc(orientation: Orientation, origin, size: Point) -> Layout {
	return {orientation, size, origin}
}
