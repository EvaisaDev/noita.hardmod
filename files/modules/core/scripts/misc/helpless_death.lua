-- Don't mind this, the counter will be used later,
-- I just want it to be as accurate as possible :)

local orig_death = death

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

local track_credit = {
	fish = true,
	longleg = true,
}

function death(type, msg, actor, ...)
	if orig_death then
		orig_death(type, msg, actor, ...)
	end

	local name = track_names[EntityGetName(GetUpdatedEntityID())]
	local key = "hardmod.judgement.kills." .. (name or "innocent")
	local is_player = actor and actor ~= 0 and IsPlayer(actor)

	if track_credit[name] and not is_player then return end

	local count = tonumber(ModSettingGet(key)) or 0
	ModSettingSet(key, count + 1)
end
