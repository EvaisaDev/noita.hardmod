local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua")---@type utils

local eid = GetUpdatedEntityID()
local shooter = utils.GetInternalEntityId(eid, "target_eid")

if not shooter or not EntityGetIsAlive(shooter) then return end

local x, y = EntityGetTransform(eid)
local shooter_x, shooter_y = EntityGetTransform(shooter)

local vcomp = (
	EntityGetFirstComponent(shooter, "CharacterDataComponent")
	or EntityGetFirstComponent(shooter, "VelocityComponent")
)

if not vcomp then return end

local vx = (x - shooter_x) * 10
local vy = (y - shooter_y) * 10

local old_vx, old_vy = ComponentGetValue2(vcomp, "mVelocity")
ComponentSetValue2(vcomp, "mVelocity", old_vx + vx, old_vy + vy)
