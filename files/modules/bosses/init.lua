-- NOTE: Do not make this module toggleable in the settings!
-- currently all the bosses this module adds are only available if `biome_map` is enabled
-- and disabling this module means some bosses might break

local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua")---@type nxml

local hooks = {} ---@type hooks

function hooks.player_spawned(player)
	EntitySetTransform(player, -3413, 2335)
end

return hooks
