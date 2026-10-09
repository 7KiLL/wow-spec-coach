-- Validates SpecKeys layouts outside the game: runs Core.lua + Layouts.lua against a fake WoW API.
-- Usage: lua scripts/check_layouts.lua <path to SpecKeys addon folder>   (Lua 5.1-5.4 or LuaJIT)
local dir = assert(arg[1], "usage: lua check_layouts.lua <SpecKeys folder>")
local unpack = unpack or table.unpack

-- fake game state
local cursor, slots, binds, macros, saved
local function reset()
	cursor, slots, macros, saved = nil, {}, {}, nil
	binds = {STALEKEY = "ACTIONBUTTON1"} -- must be cleared when ACTIONBUTTON1 is reused
end
C_SpecializationInfo = {GetSpecialization = function() return 1 end}
C_Spell = {
	GetSpellName = function(id) return type(id) == "number" and ("Spell" .. id) or nil end,
	PickupSpell = function(a) cursor = a end, -- every spell counts as learned here
}
InCombatLockdown = function() return false end
UnitClass = function() return "X", "X" end
GetMacroIndexByName = function(n) for i, m in ipairs(macros) do if m.name == n then return i end end return 0 end
CreateMacro = function(n, _, body) macros[#macros + 1] = {name = n, body = body} return #macros end
EditMacro = function(i, n, _, body) macros[i] = {name = n, body = body} end
ClearCursor = function() cursor = nil end
PickupAction = function(s) cursor = slots[s]; slots[s] = nil end
PickupMacro = function(n) if GetMacroIndexByName(n) > 0 then cursor = "m:" .. n end end
GetCursorInfo = function() return cursor end
PlaceAction = function(s) slots[s] = cursor end
GetBindingKey = function(c) local t = {} for k, v in pairs(binds) do if v == c then t[#t + 1] = k end end return unpack(t) end
SetBinding = function(k, c) binds[k] = c end
SaveBindings = function(w) saved = w end
SlashCmdList = {}
print = print or function() end

local ns = {}
for _, f in ipairs({"Core.lua", "Layouts.lua"}) do assert(loadfile(dir .. "/" .. f))("SpecKeys", ns) end

-- engine self-checks
assert(ns.command(ns.UI.elvui, 13) == "ELVUIBAR2BUTTON1" and ns.command(ns.UI.blizzard, 13) == nil, "bar 2 mapping")
assert(ns.command(ns.UI.blizzard, 61) == "MULTIACTIONBAR1BUTTON1" and ns.command(ns.UI.elvui, 150) == "MULTIACTIONBAR5BUTTON6", "shared mapping")
assert(ns.macroBody("/cast {30283}") == "/cast Spell30283", "macro placeholder")

local failed = false
for id, L in pairs(ns.layouts) do
	local errs = {}
	local function check(ok, msg) if not ok then errs[#errs + 1] = msg end end
	local ui = type(L.ui) == "table" and L.ui or ns.UI[L.ui or "blizzard"]
	check(ui, "unknown ui '" .. tostring(L.ui) .. "'")
	check(id:match("^%u+%-%d$"), "id must look like CLASS-specIndex")
	local n = 0
	for name, body in pairs(L.macros or {}) do
		n = n + 1
		check(#name <= 16, name .. ": macro name over 16 chars")
		check(#body:gsub("{%d+}", ("x"):rep(24)) <= 255, name .. ": macro body may exceed 255 chars")
	end
	check(n <= 12, "more than 12 macros leaves little room under the 18 per-character limit")
	local keys, used = {}, {}
	for i, e in ipairs(L.keys or {}) do
		local key, slot, action = e[1], e[2], e[3]
		check(type(key) == "string" and key == key:upper(), "entry " .. i .. ": key must be an upper-case binding string")
		check(type(slot) == "number" and slot >= 1 and slot <= 180 and slot % 1 == 0, "entry " .. i .. ": slot must be 1-180")
		check(not keys[key], "duplicate key " .. tostring(key)); keys[key] = true
		check(not used[slot], "duplicate slot " .. tostring(slot)); used[slot] = true
		check(type(action) == "number" or type(action) == "string", "entry " .. i .. ": bad action")
		local m = type(action) == "string" and action:match("^m:(.+)")
		check(not m or (L.macros or {})[m], "entry " .. i .. ": macro " .. tostring(m) .. " not defined")
		check(e.bind or (ui and slot and ns.command(ui, slot)), key .. ": slot " .. tostring(slot) .. " has no binding for ui " .. tostring(L.ui))
	end
	if #errs == 0 then
		reset()
		local missing = ns.apply(L)
		check(saved == 2, "binds not saved character-specific")
		check(#missing == 0, "unplaced: " .. table.concat(missing, ", "))
		check(binds.STALEKEY == nil or not used[1], "stale key on a reused command not cleared")
		for _, e in ipairs(L.keys) do check(binds[e[1]] == (e.bind or ns.command(ui, e[2])), e[1] .. " not bound") end
	end
	if #errs == 0 then
		print(("ok - %s (%s, %d keys)"):format(id, L.name or "?", #L.keys))
	else
		failed = true
		print("not ok - " .. id .. "\n  " .. table.concat(errs, "\n  "))
	end
end
os.exit(failed and 1 or 0)
