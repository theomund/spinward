/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_hex :: proc(t: ^testing.T) {
	testing.expect_value(t, new_hex(1, 1, -2), Hex(int){1, 1, -2})
	testing.expect_value(t, new_hex(1.0, 1.0, -2.0), Hex(f64){1.0, 1.0, -2.0})
}

@(test)
test_hex_index :: proc(t: ^testing.T) {
	testing.expect_value(t, hex_index(new_hex(0, 0, 0)), "0101")
	testing.expect_value(t, hex_index(new_hex(1, 0, -1)), "0201")
	testing.expect_value(t, hex_index(new_hex(0, 1, -1)), "0102")
	testing.expect_value(t, hex_index(new_hex(1, 1, -2)), "0202")
}

@(test)
test_hex_round :: proc(t: ^testing.T) {
	a := new_hex(0.0, 0.0, 0.0)
	b := new_hex(1.0, -1.0, 0.0)
	c := new_hex(0.0, -1.0, 1.0)
	d := new_hex(10.0, -20.0, 10.0)
	e := new_hex(5, -10, 5)
	f := new_hex(
		a.q * 0.4 + b.q * 0.3 + c.q * 0.3,
		a.r * 0.4 + b.r * 0.3 + c.r * 0.3,
		a.s * 0.4 + b.s * 0.3 + c.s * 0.3,
	)
	g := new_hex(
		a.q * 0.3 + b.q * 0.3 + c.q * 0.4,
		a.r * 0.3 + b.r * 0.3 + c.r * 0.4,
		a.s * 0.3 + b.s * 0.3 + c.s * 0.4,
	)

	testing.expect_value(t, hex_round(hex_lerp(a, d, 0.5)), e)
	testing.expect_value(t, hex_round(a), hex_round(hex_lerp(a, b, 0.499)))
	testing.expect_value(t, hex_round(b), hex_round(hex_lerp(a, b, 0.501)))
	testing.expect_value(t, hex_round(a), hex_round(f))
	testing.expect_value(t, hex_round(c), hex_round(g))
}
