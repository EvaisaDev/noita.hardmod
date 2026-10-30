local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local ring = GetUpdatedEntityID()
local x, y = EntityGetTransform( ring )
utils.SetInternalInt( ring, "hardmod_spawn_x", x )
utils.SetInternalInt( ring, "hardmod_spawn_y", y )
