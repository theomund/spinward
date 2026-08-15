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
	Carrillian_Assembly,
	Carter_Technocracy,
	Confederation_Of_Duncinae,
	Corellan_League,
	Darrian_Confederacy,
	Debug,
	Dzarrgh_Federate,
	Florian_League,
	Gerontocracy_Of_Ormine,
	Glorious_Empire,
	Grand_Duchy_Of_Marlheim,
	Hefrin_Colony,
	ISredNi_Protectorate,
	Islaiat_Dominate,
	Julian_Protectorate,
	Katanga_Empire,
	Lanyard_Colonies,
	Mapepire_Cluster,
	Monarchy_Of_Lod,
	Nakris_Confederation,
	Principality_Of_Bruhkarr,
	Principality_Of_Caledon,
	Rukadukaz_Republic,
	Senlis_Foederate,
	Solomani_Confederation,
	Stormhaven_Republic,
	Strend_Cluster,
	Sword_Worlds_Confederacy,
	Third_Imperium,
	Union_Of_Harmony,
	United_Followers_Of_Augurgh,
	Zhodani_Consulate,
	Zydarian_Codominium,
}

Allegiance_Data :: struct {
	color: Color,
	label: Text,
}

@(rodata)
allegiances := [Allegiance]Allegiance_Data {
	.Aslan_Hierate               = {rl.YELLOW, "Aslan Hierate"},
	.Belgardian_Sojurnate        = {rl.BLUE, "Belgardian Sojurnate"},
	.Carrillian_Assembly         = {rl.GREEN, "Carrillian Assembly"},
	.Carter_Technocracy          = {rl.BLUE, "Carter Technocracy"},
	.Confederation_Of_Duncinae   = {rl.RED, "Confederation of Ducinae"},
	.Corellan_League             = {rl.BROWN, "Corellan League"},
	.Darrian_Confederacy         = {rl.WHITE, "Darrian Confederacy"},
	.Debug                       = {rl.RAYWHITE, "Debug"},
	.Dzarrgh_Federate            = {rl.GREEN, "Dzarrgh Federate"},
	.Florian_League              = {rl.DARKGREEN, "Florian League"},
	.Gerontocracy_Of_Ormine      = {rl.WHITE, "Gerontocracy of Ormine"},
	.Glorious_Empire             = {rl.BEIGE, "Glorious Empire"},
	.Grand_Duchy_Of_Marlheim     = {rl.BLUE, "Grand Duchy of Marlheim"},
	.Hefrin_Colony               = {rl.WHITE, "Hefrin Colony"},
	.ISredNi_Protectorate        = {rl.PURPLE, "I'Sred*Ni Protectorate"},
	.Islaiat_Dominate            = {rl.BLUE, "Islaiat Dominate"},
	.Julian_Protectorate         = {rl.DARKBLUE, "Julian Protectorate"},
	.Katanga_Empire              = {rl.RED, "Katanga Empire"},
	.Lanyard_Colonies            = {rl.RED, "Lanyard Colonies"},
	.Mapepire_Cluster            = {rl.GRAY, "Mapepire Cluster"},
	.Monarchy_Of_Lod             = {rl.ORANGE, "Monarchy of Lod"},
	.Nakris_Confederation        = {rl.DARKBLUE, "Nakris Confederation"},
	.Principality_Of_Bruhkarr    = {rl.DARKPURPLE, "Principality of Bruhkarr"},
	.Principality_Of_Caledon     = {rl.DARKGREEN, "Principality of Caledon"},
	.Rukadukaz_Republic          = {rl.BLUE, "Rukadukaz Republic"},
	.Senlis_Foederate            = {rl.GREEN, "Senlis Foederate"},
	.Solomani_Confederation      = {rl.ORANGE, "Solomani Confederation"},
	.Stormhaven_Republic         = {rl.BLUE, "Stormhaven Republic"},
	.Strend_Cluster              = {rl.BROWN, "Strend Cluster"},
	.Sword_Worlds_Confederacy    = {rl.DARKBLUE, "Sword Worlds Confederacy"},
	.Third_Imperium              = {rl.RED, "Third Imperium"},
	.Unaligned                   = {rl.BLANK, ""},
	.Union_Of_Harmony            = {rl.WHITE, "Union of Harmony"},
	.United_Followers_Of_Augurgh = {rl.GREEN, "United Followers of Augurgh"},
	.Zhodani_Consulate           = {rl.BLUE, "Zhodani Consulate"},
	.Zydarian_Codominium         = {rl.PINK, "Zydarian Codominium"},
}

new_allegiance :: proc(text: Text) -> Allegiance {
	switch text {
	case "As":
		return .Aslan_Hierate
	case "BlSo":
		return .Belgardian_Sojurnate
	case "CaAs":
		return .Carrillian_Assembly
	case "CaTe":
		return .Carter_Technocracy
	case "DuCf":
		return .Confederation_Of_Duncinae
	case "CoLg":
		return .Corellan_League
	case "DaCf":
		return .Darrian_Confederacy
	case "VDzF":
		return .Dzarrgh_Federate
	case "FlLe":
		return .Florian_League
	case "GeOr":
		return .Gerontocracy_Of_Ormine
	case "GlEm":
		return .Glorious_Empire
	case "GdMh":
		return .Grand_Duchy_Of_Marlheim
	case "HeCo":
		return .Hefrin_Colony
	case "IHPr":
		return .ISredNi_Protectorate
	case "IsDo":
		return .Islaiat_Dominate
	case "JuPr":
		return .Julian_Protectorate
	case "KaEm":
		return .Katanga_Empire
	case "LyCo":
		return .Lanyard_Colonies
	case "MaCl":
		return .Mapepire_Cluster
	case "MoLo":
		return .Monarchy_Of_Lod
	case "NkCo":
		return .Nakris_Confederation
	case "PrBr":
		return .Principality_Of_Bruhkarr
	case "CaPr":
		return .Principality_Of_Caledon
	case "JuRu":
		return .Rukadukaz_Republic
	case "SeFo":
		return .Senlis_Foederate
	case "ShRp":
		return .Stormhaven_Republic
	case "SoBF", "SoCf", "SoCT", "SoNS", "SoRD", "SoWu":
		return .Solomani_Confederation
	case "StCl":
		return .Strend_Cluster
	case "SwCf":
		return .Sword_Worlds_Confederacy
	case "ImAp", "ImDa", "ImDc", "ImDd", "ImDi", "ImDs", "ImDv", "ImLa", "ImLc", "ImSy", "ImVd":
		return .Third_Imperium
	case "UnHa":
		return .Union_Of_Harmony
	case "VAug":
		return .United_Followers_Of_Augurgh
	case "ZhCo", "ZhIN":
		return .Zhodani_Consulate
	case "ZyCo":
		return .Zydarian_Codominium
	case:
		return .Unaligned
	}
}

draw_allegiance :: proc(layout: Layout, system: System, camera: Camera) {
	color := allegiances[system.allegiance].color

	if color != rl.BLANK && color != rl.RAYWHITE {
		color.a = 64
	}

	draw_hex(layout, system.hex, color, true)
}
