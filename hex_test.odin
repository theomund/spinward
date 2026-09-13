/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "core:testing"

@(test)
test_new_hex :: proc(t: ^testing.T) {
	a, _ := new_hex(1, 1, -2)
	b, _ := new_hex(1.0, 1.0, -2.0)

	testing.expect_value(t, a, Hex{1, 1, -2})
	testing.expect_value(t, b, Hex{1.0, 1.0, -2.0})
}

@(test)
test_hex_round :: proc(t: ^testing.T) {
	a, _ := new_hex(0.0, 0.0, 0.0)
	b, _ := new_hex(1.0, -1.0, 0.0)
	c, _ := new_hex(0.0, -1.0, 1.0)
	d, _ := new_hex(10.0, -20.0, 10.0)
	e, _ := new_hex(5, -10, 5)
	f, _ := new_hex(
		a.x * 0.4 + b.x * 0.3 + c.x * 0.3,
		a.y * 0.4 + b.y * 0.3 + c.y * 0.3,
		a.z * 0.4 + b.z * 0.3 + c.z * 0.3,
	)
	g, _ := new_hex(
		a.x * 0.3 + b.x * 0.3 + c.x * 0.4,
		a.y * 0.3 + b.y * 0.3 + c.y * 0.4,
		a.z * 0.3 + b.z * 0.3 + c.z * 0.4,
	)
	h, _ := hex_round(hex_lerp(a, d, 0.5))
	i, _ := hex_round(a)
	j, _ := hex_round(hex_lerp(a, b, 0.499))
	k, _ := hex_round(b)
	l, _ := hex_round(hex_lerp(a, b, 0.501))
	m, _ := hex_round(f)
	n, _ := hex_round(c)
	o, _ := hex_round(g)

	testing.expect_value(t, h, e)
	testing.expect_value(t, i, j)
	testing.expect_value(t, k, l)
	testing.expect_value(t, i, m)
	testing.expect_value(t, n, o)
}
