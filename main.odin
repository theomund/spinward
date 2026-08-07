/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:fmt"
import "core:os"

main :: proc() {
	when ODIN_DEBUG {
		tracker := new_tracker()
		defer destroy_tracker(tracker)

		context = tracker.ctx
	}

	if err := run(); err != nil {
		fmt.eprintln("Got error:", err)
		os.exit(1)
	}
}
