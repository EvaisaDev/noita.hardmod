-- I fucking suck at math

local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua")---@type utils

local eid = GetUpdatedEntityID()

local shooter = utils.GetInternalEntityId(eid, "target_eid")

if not shooter or not EntityGetIsAlive(shooter) then EntityKill(eid) return end

local x, y, angle = EntityGetTransform(eid)
local shooter_x, shooter_y = EntityGetTransform(shooter)

-- todo: maybe influence movement by the current wand tip?
-- local wx, wy, wrot, found = utils.GetWandTipPos(shooter)
-- if not found then return end

-- local dx = wx - shooter_x
-- local dy = wy - shooter_y
-- local len = math.sqrt(dx * dx + dy * dy)
-- if len == 0 then return end

-- local dir_x = dx / len
-- local dir_y = dy / len

-- local proj_angle = math.atan2(dir_y, dir_x)
-- EntitySetTransform(eid, x, y, proj_angle)

-- local proj_vcomp = EntityGetFirstComponent(eid, "VelocityComponent")
-- if proj_vcomp then
-- 	local old_vx, old_vy = ComponentGetValue2(proj_vcomp, "mVelocity")
-- 	local speed = 700
-- 	local steer = 0.7

-- 	ComponentSetValue2(
-- 		proj_vcomp, "mVelocity",
-- 		old_vx + (dir_x * speed - old_vx) * steer,
-- 		old_vy + (dir_y * speed - old_vy) * steer
-- 	)
-- end

-- EntitySetTransform(eid, x + nx * dist, y + ny * dist, (angle + arc) / 2)
-- EntitySetTransform(eid, x, y, (angle + arc) / 2)
-- local arc = math.atan2(wy - shooter_y, wx - shooter_x)
-- EntitySetTransform(eid, x, y, arc)

-- local proj_vcomp = EntityGetFirstComponent(eid, "VelocityComponent")
-- if proj_vcomp then
-- 	local vx = wx - shooter_x
-- 	local vy = wy - shooter_y

-- 	local vel = (vx ^ 2 + vy ^ 2) ^ .5

-- 	local vel_cap = math.min(50, vel)
-- 	vx = (vx / vel) * vel_cap
-- 	vy = (vy / vel) * vel_cap

-- 	local old_vx, old_vy = ComponentGetValue2(proj_vcomp, "mVelocity")
-- 	ComponentSetValue2(proj_vcomp, "mVelocity", old_vx + vx, old_vy + vy)
-- end

local vcomp = (
	EntityGetFirstComponent(shooter, "CharacterDataComponent")
	or EntityGetFirstComponent(shooter, "VelocityComponent")
)

if not vcomp then return end

local vx = x - shooter_x
local vy = y - shooter_y

if vx ^ 2 + vy ^ 2 < 200 then
	EntityAddComponent2(eid, "LifetimeComponent", { lifetime = 1 })
end

local vel = (vx ^ 2 + vy ^ 2) ^ .5

local vel_cap = math.min(80, vel)
vx = (vx / vel) * vel_cap
vy = (vy / vel) * vel_cap

local old_vx, old_vy = ComponentGetValue2(vcomp, "mVelocity")
ComponentSetValue2(vcomp, "mVelocity", old_vx + vx, old_vy + vy)
