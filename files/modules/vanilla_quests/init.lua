local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local appends = "mods/noita.hardmod/files/modules/vanilla_quests/appends/"

-- Mimicium Quest
ModLuaFileAppend("data/biome_impl/static_tile/chest_darkness.lua", appends.."chest_darkness.lua")

local mimic_reward = "data/biome_impl/static_tile/puzzle_logic_potion_mimics.lua"
utils.modifile(mimic_reward, "SEA_MIMIC", "HARDMOD_SEA_POISON")
utils.modifile(mimic_reward, "card_unlocked_sea_mimic", "card_unlocked_hardmod_sea_poison")

utils.modifile(
	"data/scripts/animals/mimic_potion.lua",
	[[CreateItemActionEntity( "SEA_MIMIC", x, y )]],
	"" -- no free spell for u! Murderer!!!
)

-- Tower Quests
ModLuaFileAppend("data/scripts/magic/__towercheck.lua", appends.."towercheck.lua")

return {}
