-- SpecKeys: /speckeys puts the layout for your current class + spec (from Layouts.lua) on the
-- action bars and binds its keys. Out of combat only. Binds are saved character-specific
-- (SaveBindings(2)), so account binds for other characters stay untouched.
-- Undo binds: Options > Keybindings > untick "Character Specific Keybindings".
local _, ns = ...
ns.layouts = {}

local GetSpecialization = C_SpecializationInfo and C_SpecializationInfo.GetSpecialization or GetSpecialization

-- Binding command prefix per 12-slot action page (page = floor((slot - 1) / 12)).
-- Blizzard and ElvUI agree except ElvUI bar 2 (page 1) and bars 7-10 (pages 6-9).
local BLIZZARD = {
	[0] = "ACTIONBUTTON", [2] = "MULTIACTIONBAR3BUTTON", [3] = "MULTIACTIONBAR4BUTTON",
	[4] = "MULTIACTIONBAR2BUTTON", [5] = "MULTIACTIONBAR1BUTTON",
	[12] = "MULTIACTIONBAR5BUTTON", [13] = "MULTIACTIONBAR6BUTTON", [14] = "MULTIACTIONBAR7BUTTON",
}
local ELVUI = setmetatable({
	[1] = "ELVUIBAR2BUTTON", [6] = "ELVUIBAR7BUTTON", [7] = "ELVUIBAR8BUTTON",
	[8] = "ELVUIBAR9BUTTON", [9] = "ELVUIBAR10BUTTON",
}, {__index = BLIZZARD})
ns.UI = {blizzard = BLIZZARD, elvui = ELVUI}

function ns.command(ui, slot)
	local prefix = ui[math.floor((slot - 1) / 12)]
	return prefix and prefix .. ((slot - 1) % 12 + 1)
end

-- "{30283}" in a macro body becomes the spell's name in the client's language.
function ns.macroBody(body)
	return (body:gsub("{(%d+)}", function(id) return C_Spell.GetSpellName(tonumber(id)) end))
end

function ns.apply(layout)
	local ui = type(layout.ui) == "table" and layout.ui or ns.UI[layout.ui or "blizzard"]
	for name, body in pairs(layout.macros or {}) do
		local i = GetMacroIndexByName(name)
		if i == 0 then
			pcall(CreateMacro, name, 134400, ns.macroBody(body), true)
		else
			EditMacro(i, name, 134400, ns.macroBody(body))
		end
	end

	local missing = {}
	for _, e in ipairs(layout.keys) do
		local key, slot, action = e[1], e[2], e[3]
		ClearCursor()
		PickupAction(slot); ClearCursor() -- empty the slot first
		local macro = type(action) == "string" and action:match("^m:(.+)")
		if macro then PickupMacro(macro) else pcall(C_Spell.PickupSpell, action) end
		if GetCursorInfo() then
			PlaceAction(slot)
		else
			missing[#missing + 1] = (type(action) == "number" and C_Spell.GetSpellName(action)) or tostring(action)
		end
		ClearCursor()

		local cmd = e.bind or ns.command(ui, slot)
		if cmd then
			for _, old in ipairs({GetBindingKey(cmd)}) do SetBinding(old) end
			SetBinding(key, cmd)
		else
			missing[#missing + 1] = key .. " (slot " .. slot .. " is not on a bindable bar)"
		end
	end
	SaveBindings(2)
	return missing
end

SLASH_SPECKEYS1 = "/speckeys"
SlashCmdList.SPECKEYS = function()
	if InCombatLockdown() then return print("SpecKeys: leave combat first.") end
	local _, class = UnitClass("player")
	local id = class .. "-" .. tostring(GetSpecialization())
	local layout = ns.layouts[id]
	if not layout then return print("SpecKeys: no layout for " .. id .. " yet. Ask your agent to add one.") end
	local missing = ns.apply(layout)
	print("SpecKeys: applied " .. (layout.name or id) .. "."
		.. (#missing > 0 and (" Not placed (talent not picked / item missing?): " .. table.concat(missing, ", ")) or ""))
end
