local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml
local imutil = dofile_once("mods/noita.hardmod/lib/image_utils.lua") ---@type image_utils
local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local dir = "mods/noita.hardmod/files/modules/holy_mountain_items/"

for file in nxml.edit_file("data/entities/items/pickup/spell_refresh.xml") do
	local item = file:first_of("ItemComponent")
	if item then item:set("auto_pickup", false) end
end

for file in nxml.edit_file("data/entities/items/pickup/heart_fullhp.xml") do
	local item = file:first_of("ItemComponent")
	if item then item:set("auto_pickup", false) end
end

ModLuaFileAppend("data/scripts/biomes/temple_altar.lua", dir.."altar_append.lua")
ModLuaFileAppend("data/scripts/biomes/boss_arena.lua", dir.."boss_arena_append.lua")
ModLuaFileAppend("data/scripts/buildings/workshop_trigger_check_stats.lua", dir.."scripts/workshop_trigger_check_stats_append.lua")
utils.modifile("data/entities/items/pickup/perk_reroll.xml",
	[["data/scripts/perks/perk_reroll_init.lua"]],
	[["mods/noita.hardmod/files/modules/holy_mountain_items/scripts/perk_reroll_init.lua"]]
)

imutil.ReplaceImage("data/biome_impl/temple/altar_background.png", dir.."gfx/altar_background.png")
imutil.ReplaceImage("data/biome_impl/temple/altar_visual.png", dir.."gfx/altar_visual.png")
imutil.ReplaceImage("data/biome_impl/temple/altar.png", dir.."gfx/altar.png")

return {}