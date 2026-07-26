/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

Allegiance :: enum {
	Unaligned,
	Darrian_Confederacy,
	Sword_Worlds_Confederacy,
	Third_Imperium,
	Zhodani_Consulate,
}

new_allegiance :: proc(text: string) -> Allegiance {
	switch text {
	case "DaCf":
		return .Darrian_Confederacy
	case "ImDd":
		return .Third_Imperium
	case "SwCf":
		return .Sword_Worlds_Confederacy
	case "ZhIN":
		return .Zhodani_Consulate
	case:
		return .Unaligned
	}
}

draw_allegiance :: proc(layout: Layout, system: System) {
	color: rl.Color

	#partial switch system.allegiance {
	case .Darrian_Confederacy:
		color = rl.WHITE
	case .Third_Imperium:
		color = rl.RED
	case .Sword_Worlds_Confederacy:
		color = rl.DARKBLUE
	case .Zhodani_Consulate:
		color = rl.BLUE
	case .Unaligned:
		return
	}

	color.a = 64

	draw_hex(layout, system.hex, color, true)
}
