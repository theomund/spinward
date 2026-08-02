/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

Allegiance :: enum {
	Unaligned,
	Aslan_Hierate,
	Belgardian_Sojurnate,
	Corellan_League,
	Darrian_Confederacy,
	Florian_League,
	Glorious_Empire,
	Hefrin_Colony,
	ISredNi_Protectorate,
	Katanga_Empire,
	Mapepire_Cluster,
	Monarchy_Of_Lod,
	Nakris_Confederation,
	Principality_Of_Bruhkarr,
	Senlis_Foederate,
	Stormhaven_Republic,
	Strend_Cluster,
	Sword_Worlds_Confederacy,
	Third_Imperium,
	Vargr,
	Zhodani_Consulate,
	Zydarian_Codominium,
}

new_allegiance :: proc(text: string) -> Allegiance {
	switch text {
	case "As":
		return .Aslan_Hierate
	case "BlSo":
		return .Belgardian_Sojurnate
	case "CoLg":
		return .Corellan_League
	case "DaCf":
		return .Darrian_Confederacy
	case "FlLe":
		return .Florian_League
	case "GlEm":
		return .Glorious_Empire
	case "HeCo":
		return .Hefrin_Colony
	case "IHPr":
		return .ISredNi_Protectorate
	case "KaEm":
		return .Katanga_Empire
	case "MaCl":
		return .Mapepire_Cluster
	case "MoLo":
		return .Monarchy_Of_Lod
	case "NkCo":
		return .Nakris_Confederation
	case "PrBr":
		return .Principality_Of_Bruhkarr
	case "SeFo":
		return .Senlis_Foederate
	case "ShRp":
		return .Stormhaven_Republic
	case "StCl":
		return .Strend_Cluster
	case "SwCf":
		return .Sword_Worlds_Confederacy
	case "ImDd", "ImDi", "ImDv", "ImLc":
		return .Third_Imperium
	case "VAug", "VDzF":
		return .Vargr
	case "ZhIN":
		return .Zhodani_Consulate
	case "ZyCo":
		return .Zydarian_Codominium
	case:
		return .Unaligned
	}
}

draw_allegiance :: proc(layout: Layout, system: System) {
	color: rl.Color

	#partial switch system.allegiance {
	case .Aslan_Hierate:
		color = rl.YELLOW
	case .Belgardian_Sojurnate:
		color = rl.BLUE
	case .Corellan_League:
		color = rl.BROWN
	case .Darrian_Confederacy:
		color = rl.WHITE
	case .Florian_League:
		color = rl.DARKGREEN
	case .Glorious_Empire:
		color = rl.BEIGE
	case .Hefrin_Colony:
		color = rl.WHITE
	case .ISredNi_Protectorate:
		color = rl.PURPLE
	case .Katanga_Empire:
		color = rl.RED
	case .Mapepire_Cluster:
		color = rl.GRAY
	case .Monarchy_Of_Lod:
		color = rl.ORANGE
	case .Nakris_Confederation:
		color = rl.DARKBLUE
	case .Principality_Of_Bruhkarr:
		color = rl.DARKPURPLE
	case .Senlis_Foederate:
		color = rl.GREEN
	case .Stormhaven_Republic:
		color = rl.BLUE
	case .Strend_Cluster:
		color = rl.BROWN
	case .Sword_Worlds_Confederacy:
		color = rl.DARKBLUE
	case .Third_Imperium:
		color = rl.RED
	case .Vargr:
		color = rl.GREEN
	case .Zhodani_Consulate:
		color = rl.BLUE
	case .Zydarian_Codominium:
		color = rl.PINK
	case .Unaligned:
		return
	}

	color.a = 64

	draw_hex(layout, system.hex, color, true)
}
