-- One entry per "CLASSTOKEN-specIndex" (UnitClass token + GetSpecialization() index).
-- keys = {key, action slot, spell ID | spell name | "m:" .. macro name [, bind = "BINDING COMMAND"]}
-- Spell IDs work in every client language; "{id}" in a macro body becomes the localized name.
-- Item names in macros (potions, healthstones) stay as written: they match every crafted rank.
local _, ns = ...

-- Example: Demonology Warlock, Diabolist, Midnight 12.1 (Wowhead / NotWarlock), ElvUI, WASD,
-- hottest abilities left to right. Tested on an enUS client.
ns.layouts["WARLOCK-2"] = {
	name = "Demonology (Diabolist)",
	ui = "elvui",
	macros = {
		SK_Fury   = "#showtooltip\n/cast [@cursor] {30283}",
		SK_Gate   = "#showtooltip\n/cast [@cursor] {111771}",
		SK_Tyrant = "#showtooltip {265187}\n/use 13\n/cast {265187}",
		SK_Grim   = "#showtooltip [known:1276452] {1276452}; [known:1276467] {1276467}\n/cast [@focus,exists][] {1276467}\n/cast [@mouseover,exists,help][] {1276452}",
		SK_Stone  = "#showtooltip [known:Pact of Gluttony] Demonic Healthstone; Healthstone\n/cast [known:Soulburn] {385899}\n/use [known:Pact of Gluttony] Demonic Healthstone; Healthstone",
		SK_SS     = "#showtooltip {20707}\n/cast [@mouseover,help,exists][] {20707}",
		SK_Felg   = "#showtooltip {30146}\n/cast {333889}\n/cast {30146}",
		SK_HPot   = "#showtooltip\n/use Concentrated Silvermoon Health Potion",
		SK_DPot   = "#showtooltip\n/use Light's Potential",
	},
	keys = {
		-- bar 1, no modifier: rotation, reactions, cooldowns, big defensives
		{"Q", 1, 686},             -- Shadow Bolt: filler, most pressed (becomes Infernal Bolt)
		{"E", 2, 105174},          -- Hand of Gul'dan: main spender (becomes Ruination)
		{"R", 3, 264178},          -- Demonbolt: Demonic Core spender
		{"T", 4, "m:SK_Fury"},     -- Shadowfury at cursor
		{"F", 5, 104316},          -- Call Dreadstalkers
		{"G", 6, "Command Demon"}, -- Axe Toss: stun / kick (no current retail ID on Wowhead)
		{"1", 7, 196277},          -- Implosion
		{"2", 8, "m:SK_Tyrant"},   -- Summon Demonic Tyrant + top trinket
		{"3", 9, "m:SK_Grim"},     -- Grimoire: Imp Lord / Fel Ravager (kicks focus)
		{"4", 10, 1276672},        -- Summon Doomguard (Doomguard M+ build only)
		{"Z", 11, 104773},         -- Unending Resolve
		{"X", 12, 108416},         -- Dark Pact
		-- bar 2, Shift: utility and movement
		{"SHIFT-Q", 13, 1714},     -- Curse of Tongues
		{"SHIFT-E", 14, 5782},     -- Fear
		{"SHIFT-R", 15, 111400},   -- Burning Rush
		{"SHIFT-T", 16, "m:SK_Gate"},
		{"SHIFT-F", 17, 48020},    -- Demonic Circle: Teleport
		{"SHIFT-G", 18, 48018},    -- Demonic Circle
		{"SHIFT-1", 19, 385899},   -- Soulburn
		{"SHIFT-2", 20, "m:SK_DPot"},
		{"SHIFT-3", 21, "m:SK_SS"},
		{"SHIFT-4", 22, "m:SK_Felg"},
		{"SHIFT-Z", 23, 234153},   -- Drain Life
		{"SHIFT-X", 24, 334275},   -- Curse of Exhaustion
		-- bar 3: overflow
		{"C", 25, "m:SK_Stone"},
		{"V", 26, 6789},           -- Mortal Coil
		{"SHIFT-C", 27, "m:SK_HPot"},
		{"SHIFT-V", 28, 710},      -- Banish
		{"CTRL-Q", 29, "Create Soulwell"},
		{"CTRL-E", 30, 6201},      -- Create Healthstone
	},
}
