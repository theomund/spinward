/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:strings"

new_string :: proc(value: string) -> (str: string, err: Error) {
	str = strings.clone(value) or_return

	return
}

destroy_string :: proc(str: string) -> Error {
	if str != "" {
		delete(str) or_return
	}

	return nil
}
