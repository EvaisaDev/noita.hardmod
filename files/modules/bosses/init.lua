-- NOTE: Do not make this module toggleable in the settings!
-- currently all the bosses this module adds are only available if `biome_map` is enabled
-- and disabling this module means some bosses might break

local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua")---@type nxml
local hooks = {} ---@type hooks

-- ModLuaFileAppend("data/scripts/animals/longleg_love.lua", "mods/noita.hardmod/files/modules/bosses/appends/longleg_love.lua")

for file in nxml.edit_file("data/entities/animals/longleg.xml") do
	file:create_child("LuaComponent", {
		script_source_file = "mods/noita.hardmod/files/modules/bosses/scripts/hamis_init.lua",
		execute_on_added = true,
		remove_after_executed = true,
	})
end

function hooks.player_spawned(player)
	EntitySetTransform(player, -3413, 2335)
end

return hooks
