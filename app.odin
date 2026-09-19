/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

run :: proc() -> Error {
	new_window() or_return
	defer destroy_window()

	sectors := read_sectors() or_return
	defer delete(sectors)

	render(sectors[:]) or_return

	for sector in sectors {
		destroy_sector(sector) or_return
	}

	return nil
}
