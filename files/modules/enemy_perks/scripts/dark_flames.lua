local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

SetRandomSeed(GameGetFrameNum(), pos_x + pos_y + entity_id)

local size = 8

local radius_cap = #EntityGetInRadiusWithTag(pos_x, pos_y, size*1.3, "hardmod_darkflame")*.07
local total_cap = #EntityGetWithTag("hardmod_darkflame")*.005
if Random() < math.max(radius_cap, total_cap) then return end

pos_x = pos_x + Random(-size, size)
pos_y = pos_y + Random(-size, size)

utils.ShootProjectile(entity_id, "data/entities/projectiles/darkflame_stationary.xml", pos_x, pos_y, 0, 0)