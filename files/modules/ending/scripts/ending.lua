local modules = dofile_once("mods/noita.hardmod/modules.lua")---@type module_list
local give_reward = true

for _,module in pairs(modules.integral_list) do
	if ModSettingGet("noita.hardmod."..module..".disabled") then
		give_reward = false
	end
end

AddFlagPersistent(give_reward and "hardmod_game_completed" or "hardmod_false_game_completed")

if GameHasFlagRun("hardmod_hell") then
	AddFlagPersistent(give_reward and "hardmod_hell_completed" or "hardmod_false_hell_completed")
end
