local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

local strength = 3
local radius = 65

for i,crystal in ipairs(EntityGetInRadiusWithTag(x, y, radius, "hm_crystal") or {}) do
	local cx,cy = EntityGetTransform(crystal)
	local dir = 0 - math.atan2(y - cy, x - cx)
	local vx,vy = math.floor(math.cos(dir) * strength), math.floor(0 - math.sin(dir) * strength)
	local distance = math.sqrt((cx-x)^2 + (cy-y)^2)
	local velx,vely = vx * distance/radius, vy * distance/radius

	PhysicsApplyForce(crystal, velx, vely)
end