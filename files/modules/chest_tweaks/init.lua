local lootlib = dofile_once("mods/noita.hardmod/lib/lootlib.lua")---@type lootlib

lootlib.init_patches("mods/noita.hardmod/lib/lootlib.lua")

lootlib.add_patch_script("mods/noita.hardmod/files/modules/chest_tweaks/loot/chest.lua")
lootlib.add_patch_script("mods/noita.hardmod/files/modules/chest_tweaks/loot/great_chest.lua")
lootlib.add_patch_script("mods/noita.hardmod/files/modules/chest_tweaks/loot/perk_modifications.lua")

ModLuaFileAppend("data/scripts/items/gold_pickup.lua", "mods/noita.hardmod/files/modules/chest_tweaks/appends/gold_pickup.lua")

return {}
