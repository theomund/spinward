/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_allegiance :: proc(t: ^testing.T) {
	testing.expect_value(t, new_allegiance("DaCf"), Allegiance.Darrian_Confederacy)
	testing.expect_value(t, new_allegiance("ImDd"), Allegiance.Third_Imperium)
	testing.expect_value(t, new_allegiance("SwCf"), Allegiance.Sword_Worlds_Confederacy)
	testing.expect_value(t, new_allegiance("ZhIN"), Allegiance.Zhodani_Consulate)
	testing.expect_value(t, new_allegiance(""), Allegiance.Unaligned)
}
