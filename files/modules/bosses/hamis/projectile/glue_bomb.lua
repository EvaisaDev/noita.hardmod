dofile_once("data/scripts/lib/utilities.lua")
SetRandomSeed(GameGetFrameNum(), 321)

local eid = GetUpdatedEntityID()
local x, y = EntityGetTransform(eid)
local proj = "data/entities/projectiles/glue_shot.xml"
-- local proj = "data/entities/projectiles/glue.xml"

local count = 4

local angle = math.rad(Random(0,359))
local length = 70
local angle_inc = (math.pi * 2) / count

for _=1,count do
	local vx = math.cos(angle) * length
	local vy = 0 - math.sin(angle) * length

	local clone_id = shoot_projectile_from_projectile(eid, proj, x, y, vx, vy)
	EntityAddTag(clone_id, "projectile_cloned")

	angle = angle + angle_inc
end
