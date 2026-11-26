local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

SetRandomSeed(GameGetFrameNum(), pos_x + pos_y + entity_id)

local range = 8

local dark_flames = EntityGetWithTag("hardmod_darkflame")
for i=1,#dark_flames-200 do
    EntityKill(dark_flames[i])
end

pos_x = pos_x + Random(-range, range)
pos_y = pos_y + Random(-range, range)

utils.ShootProjectile(entity_id, "data/entities/projectiles/darkflame_stationary.xml", pos_x, pos_y, 0, 0)