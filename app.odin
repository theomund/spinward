/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

run :: proc() -> Error {
	new_window() or_return
	defer delete_window()

	camera := new_camera()

	sector := read_sector() or_return
	defer delete_sector(sector)

	render(sector, &camera)

	return nil
}
