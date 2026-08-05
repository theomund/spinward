/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

run :: proc() -> Error {
	new_window() or_return
	defer destroy_window()

	camera := new_camera()

	sectors := read_sectors() or_return

	render(sectors, &camera) or_return

	for _, sector in sectors {
		destroy_sector(sector)
	}

	delete(sectors)

	return nil
}
