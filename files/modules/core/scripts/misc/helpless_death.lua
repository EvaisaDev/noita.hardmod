local track_names = {
	["$animal_fish"] = "fish",
	["$animal_longleg"] = "longleg",
	["$animal_duck"] = "duck",
	["$animal_elk"] = "elk",
	["$animal_scorpion"] = "scorpion",
	["$animal_sheep_bat"] = "sheep_bat",
	["$animal_sheep_fly"] = "sheep_fly",
	["$animal_sheep"] = "sheep",
	["$animal_deer"] = "deer",
}

local not_fully_innocent = {
	["longleg"] = true,
}

---@param key string
local function increment_counter(key)
	ModSettingSet(key, (tonumber(ModSettingGet(key)) or 0) + 1)
	GlobalsSetValue(key, tostring((tonumber(GlobalsGetValue(key)) or 0) + 1))
end

local orig_death = death
function death(type, msg, actor, ...)
	if orig_death then
		orig_death(type, msg, actor, ...)
	end

	local key = "hardmod.judgement.kills"
	local name = track_names[EntityGetName(GetUpdatedEntityID())]

	if not actor or actor == 0 or not IsPlayer(actor) then return end

	if not not_fully_innocent[name] then
		increment_counter(key)
	end

	if name then
		increment_counter(key.."."..name)
	end
end
