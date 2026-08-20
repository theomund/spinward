/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import rl "vendor:raylib"

Allegiance :: enum {
	Unaligned,
	Anubian_Trade_Coalition,
	Aslan_Hierate,
	Belgardian_Sojurnate,
	Carrillian_Assembly,
	Carter_Technocracy,
	Confederation_Of_Duncinae,
	Corellan_League,
	Council_Of_Leh_Perash,
	Cytralin_Unity,
	Darrian_Confederacy,
	Debug,
	Dzarrgh_Federate,
	Federation_Of_Heron,
	Florian_League,
	Gamma_Republic,
	Gerontocracy_Of_Ormine,
	Glimmerdrift_Federation,
	Glorious_Empire,
	Gniivi_Collective,
	Grand_Duchy_Of_Marlheim,
	Grand_Duchy_Of_Stoner,
	Hefrin_Colony,
	Hegemony_Of_Lorean,
	Hive_Federation,
	ISredNi_Protectorate,
	Islaiat_Dominate,
	Julian_Protectorate,
	Katanga_Empire,
	Khuur_League,
	Lanyard_Colonies,
	Loyal_Nineworlds_Republic,
	Mapepire_Cluster,
	Maskai_Empire,
	Monarchy_Of_Lod,
	Nakris_Confederation,
	Outcasts_Of_The_Whispering_Sky,
	Principality_Of_Bruhkarr,
	Principality_Of_Caledon,
	Ral_Ranta,
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
	.Anubian_Trade_Coalition        = {rl.GREEN, "Anubian Trade Coalition"},
	.Aslan_Hierate                  = {rl.YELLOW, "Aslan Hierate"},
	.Belgardian_Sojurnate           = {rl.BLUE, "Belgardian Sojurnate"},
	.Carrillian_Assembly            = {rl.GREEN, "Carrillian Assembly"},
	.Carter_Technocracy             = {rl.BLUE, "Carter Technocracy"},
	.Confederation_Of_Duncinae      = {rl.RED, "Confederation of Ducinae"},
	.Corellan_League                = {rl.BROWN, "Corellan League"},
	.Council_Of_Leh_Perash          = {rl.DARKBLUE, "Council of Leh Perash"},
	.Cytralin_Unity                 = {rl.ORANGE, "Cytralin Unity"},
	.Darrian_Confederacy            = {rl.WHITE, "Darrian Confederacy"},
	.Debug                          = {rl.RAYWHITE, "Debug"},
	.Dzarrgh_Federate               = {rl.GREEN, "Dzarrgh Federate"},
	.Federation_Of_Heron            = {rl.ORANGE, "Federation of Heron"},
	.Florian_League                 = {rl.DARKGREEN, "Florian League"},
	.Gamma_Republic                 = {rl.WHITE, "Gamma Republic"},
	.Gerontocracy_Of_Ormine         = {rl.WHITE, "Gerontocracy of Ormine"},
	.Glimmerdrift_Federation        = {rl.BLUE, "Glimmerdrift Federation"},
	.Glorious_Empire                = {rl.BEIGE, "Glorious Empire"},
	.Gniivi_Collective              = {rl.PINK, "Gniivi_Collective"},
	.Grand_Duchy_Of_Marlheim        = {rl.BLUE, "Grand Duchy of Marlheim"},
	.Grand_Duchy_Of_Stoner          = {rl.PURPLE, "Grand Duchy of Stoner"},
	.Hefrin_Colony                  = {rl.WHITE, "Hefrin Colony"},
	.Hegemony_Of_Lorean             = {rl.BLUE, "Hegemony of Lorean"},
	.Hive_Federation                = {rl.PURPLE, "Hive Federation"},
	.ISredNi_Protectorate           = {rl.PURPLE, "I'Sred*Ni Protectorate"},
	.Islaiat_Dominate               = {rl.BLUE, "Islaiat Dominate"},
	.Julian_Protectorate            = {rl.DARKBLUE, "Julian Protectorate"},
	.Katanga_Empire                 = {rl.RED, "Katanga Empire"},
	.Khuur_League                   = {rl.YELLOW, "Khuur League"},
	.Lanyard_Colonies               = {rl.RED, "Lanyard Colonies"},
	.Loyal_Nineworlds_Republic      = {rl.DARKGRAY, "Loyal Nineworlds Republic"},
	.Mapepire_Cluster               = {rl.GRAY, "Mapepire Cluster"},
	.Maskai_Empire                  = {rl.PINK, "Maskai Empire"},
	.Monarchy_Of_Lod                = {rl.ORANGE, "Monarchy of Lod"},
	.Nakris_Confederation           = {rl.DARKBLUE, "Nakris Confederation"},
	.Outcasts_Of_The_Whispering_Sky = {rl.WHITE, "Outcasts of the Whispering Sky"},
	.Principality_Of_Bruhkarr       = {rl.DARKPURPLE, "Principality of Bruhkarr"},
	.Principality_Of_Caledon        = {rl.DARKGREEN, "Principality of Caledon"},
	.Ral_Ranta                      = {rl.PURPLE, "Ral Ranta"},
	.Rukadukaz_Republic             = {rl.BLUE, "Rukadukaz Republic"},
	.Senlis_Foederate               = {rl.GREEN, "Senlis Foederate"},
	.Solomani_Confederation         = {rl.ORANGE, "Solomani Confederation"},
	.Stormhaven_Republic            = {rl.BLUE, "Stormhaven Republic"},
	.Strend_Cluster                 = {rl.BROWN, "Strend Cluster"},
	.Sword_Worlds_Confederacy       = {rl.DARKBLUE, "Sword Worlds Confederacy"},
	.Third_Imperium                 = {rl.RED, "Third Imperium"},
	.Unaligned                      = {rl.BLANK, ""},
	.Union_Of_Harmony               = {rl.WHITE, "Union of Harmony"},
	.United_Followers_Of_Augurgh    = {rl.GREEN, "United Followers of Augurgh"},
	.Zhodani_Consulate              = {rl.BLUE, "Zhodani Consulate"},
	.Zydarian_Codominium            = {rl.PINK, "Zydarian Codominium"},
}

new_allegiance :: proc(text: Text) -> Allegiance {
	switch text {
	case "AnTC":
		return .Anubian_Trade_Coalition
	case "As",
	     "AsMw",
	     "AsSc",
	     "AsT0",
	     "AsT1",
	     "AsT2",
	     "AsT3",
	     "AsT4",
	     "AsT5",
	     "AsT6",
	     "AsT7",
	     "AsT8",
	     "AsT9",
	     "AsTz",
	     "AsTv",
	     "AsVc",
	     "AsWc",
	     "AsXX":
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
	case "CoLp":
		return .Council_Of_Leh_Perash
	case "CyUn":
		return .Cytralin_Unity
	case "DaCf":
		return .Darrian_Confederacy
	case "VDzF":
		return .Dzarrgh_Federate
	case "FeHe":
		return .Federation_Of_Heron
	case "FlLe":
		return .Florian_League
	case "GaRp":
		return .Gamma_Republic
	case "GeOr":
		return .Gerontocracy_Of_Ormine
	case "GnCl":
		return .Gniivi_Collective
	case "GlFe":
		return .Glimmerdrift_Federation
	case "GlEm":
		return .Glorious_Empire
	case "GdMh":
		return .Grand_Duchy_Of_Marlheim
	case "GdSt":
		return .Grand_Duchy_Of_Stoner
	case "HeCo":
		return .Hefrin_Colony
	case "JuHl":
		return .Hegemony_Of_Lorean
	case "HvFd":
		return .Hive_Federation
	case "IHPr":
		return .ISredNi_Protectorate
	case "IsDo":
		return .Islaiat_Dominate
	case "JuPr":
		return .Julian_Protectorate
	case "KaEm":
		return .Katanga_Empire
	case "KhLe":
		return .Khuur_League
	case "LyCo":
		return .Lanyard_Colonies
	case "LnRp":
		return .Loyal_Nineworlds_Republic
	case "MaCl":
		return .Mapepire_Cluster
	case "MaEm":
		return .Maskai_Empire
	case "MoLo":
		return .Monarchy_Of_Lod
	case "NkCo":
		return .Nakris_Confederation
	case "OcWs":
		return .Outcasts_Of_The_Whispering_Sky
	case "PrBr":
		return .Principality_Of_Bruhkarr
	case "CaPr":
		return .Principality_Of_Caledon
	case "RaRa":
		return .Ral_Ranta
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
	case "ImAp",
	     "ImDa",
	     "ImDc",
	     "ImDd",
	     "ImDg",
	     "ImDi",
	     "ImDs",
	     "ImDv",
	     "ImLa",
	     "ImLc",
	     "ImLu",
	     "ImSy",
	     "ImVd":
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
