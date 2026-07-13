/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package viewer

import "core:testing"

@(test)
test_hex_index :: proc(t: ^testing.T) {
	testing.expect_value(t, hex_index(0, 0), "0101")
	testing.expect_value(t, hex_index(1, 0), "0201")
	testing.expect_value(t, hex_index(0, 1), "0102")
	testing.expect_value(t, hex_index(1, 1), "0202")
}
