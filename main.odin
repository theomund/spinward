/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:os"

main :: proc() {
	when ODIN_DEBUG {
		tracker := new_tracker()
		context = tracker.ctx

		defer delete_tracker(tracker)
	}

	if err := run(); err != nil {
		os.exit(1)
	}
}
