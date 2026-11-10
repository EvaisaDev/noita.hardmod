local lootlib = dofile_once("mods/noita.hardmod/lib/lootlib.lua")---@type lootlib
local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua")---@type utils

lootlib.init_patches("mods/noita.hardmod/lib/lootlib.lua")

lootlib.add_patch_script("mods/noita.hardmod/files/modules/chest_tweaks/loot/chest.lua")
lootlib.add_patch_script("mods/noita.hardmod/files/modules/chest_tweaks/loot/great_chest.lua")
lootlib.add_patch_script("mods/noita.hardmod/files/modules/chest_tweaks/loot/perk_modifications.lua")

ModLuaFileAppend("data/scripts/items/gold_pickup.lua", "mods/noita.hardmod/files/modules/chest_tweaks/appends/gold_pickup.lua")

local pacifist_chests = "dofile_once( \"mods/noita.hardmod/files/modules/chest_tweaks/scripts/pacifist_chests.lua\" )"
utils.patchifile("data/scripts/buildings/workshop_trigger_check_stats.lua", {
	{
		from = [[
		local eid = EntityLoad( "data/entities/items/pickup/chest_random.xml", sx, sy )
		change_entity_ingame_name( eid, "$item_chest_treasure_pacifist" )]],
		to = "\n\t\t"..pacifist_chests..".spawn( sx, sy )",
		count = 1,
	},
	{
		from = [[print("KILLED ALL")]],
		to = "print(\"KILLED ALL\")\n\t\t"..pacifist_chests..".reset()",
		count = 1,
	},
})

utils.modifile(
	"data/scripts/biome_scripts.lua",
	[[heart_spawn_percent = 0.7]],
	[[heart_spawn_percent = 0.65]]
)

return {}
