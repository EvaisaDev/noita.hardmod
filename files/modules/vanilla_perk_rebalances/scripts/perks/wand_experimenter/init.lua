dofile_once("mods/noita.hardmod/files/modules/vanilla_perk_rebalances/scripts/perks/wand_experimenter/shared.lua")

local wand = GetUpdatedEntityID()

local state = GetStoredWandState(wand)
local new_state = GetNewWandState(wand)

if IsWandStateInvalid(state, new_state) then
	print("loaded invalid wand")
	return
end

StoreWandState(wand, new_state)

EntityAddComponent2(wand, "LuaComponent", {
	_tags="enabled_in_hand,enabled_in_inventory",
	_enabled=false,
	script_source_file="mods/noita.hardmod/files/modules/vanilla_perk_rebalances/scripts/perks/wand_experimenter/check.lua",
	execute_every_n_frame=1,
	execute_times=-1
})
