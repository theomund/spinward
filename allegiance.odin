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
	Dzarrgh_Federate,
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
	United_Followers_Of_Augurgh,
	Zhodani_Consulate,
	Zydarian_Codominium,
}

Allegiance_Data :: struct {
	color: rl.Color,
	label: string,
}

@(rodata)
allegiances := [Allegiance]Allegiance_Data {
	.Aslan_Hierate               = {rl.YELLOW, "Aslan Hierate"},
	.Belgardian_Sojurnate        = {rl.BLUE, "Belgardian Sojurnate"},
	.Corellan_League             = {rl.BROWN, "Corellan League"},
	.Darrian_Confederacy         = {rl.WHITE, "Darrian Confederacy"},
	.Dzarrgh_Federate            = {rl.GREEN, "Dzarrgh Federate"},
	.Florian_League              = {rl.DARKGREEN, "Florian League"},
	.Glorious_Empire             = {rl.BEIGE, "Glorious Empire"},
	.Hefrin_Colony               = {rl.WHITE, "Hefrin Colony"},
	.ISredNi_Protectorate        = {rl.PURPLE, "I'Sred*Ni Protectorate"},
	.Katanga_Empire              = {rl.RED, "Katanga Empire"},
	.Mapepire_Cluster            = {rl.GRAY, "Mapepire Cluster"},
	.Monarchy_Of_Lod             = {rl.ORANGE, "Monarchy of Lod"},
	.Nakris_Confederation        = {rl.DARKBLUE, "Nakris Confederation"},
	.Principality_Of_Bruhkarr    = {rl.DARKPURPLE, "Principality of Bruhkarr"},
	.Senlis_Foederate            = {rl.GREEN, "Senlis Foederate"},
	.Stormhaven_Republic         = {rl.BLUE, "Stormhaven Republic"},
	.Strend_Cluster              = {rl.BROWN, "Strend Cluster"},
	.Sword_Worlds_Confederacy    = {rl.DARKBLUE, "Sword Worlds Confederacy"},
	.Third_Imperium              = {rl.RED, "Third Imperium"},
	.Unaligned                   = {rl.BLANK, ""},
	.United_Followers_Of_Augurgh = {rl.GREEN, "United Followers of Augurgh"},
	.Zhodani_Consulate           = {rl.BLUE, "Zhodani Consulate"},
	.Zydarian_Codominium         = {rl.PINK, "Zydarian Codominium"},
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
	case "VDzF":
		return .Dzarrgh_Federate
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
	case "VAug":
		return .United_Followers_Of_Augurgh
	case "ZhIN":
		return .Zhodani_Consulate
	case "ZyCo":
		return .Zydarian_Codominium
	case:
		return .Unaligned
	}
}

draw_allegiance :: proc(layout: Layout, system: System) {
	color := allegiances[system.allegiance].color
	color.a = 64

	draw_hex(layout, system.hex, color, true)
}
