local eid = GetUpdatedEntityID()

local parent_id = EntityGetParent(eid)

if parent_id == 0 then
	parent_id = eid
end

for _,pcomp in pairs(EntityGetComponent(parent_id, "ProjectileComponent") or {}) do
	local x = ComponentGetValue2(pcomp, "damage_every_x_frames")
	ComponentSetValue2(pcomp, "damage_every_x_frames", math.max(x, 10))
end

-- local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua")---@type utils
-- local eid = GetUpdatedEntityID()

-- local count = utils.GetInternalInt(eid, "hardmod_piercing_count") or 0
-- count = count + 5

-- if count >= 50 then
-- 	count = -1
-- end

-- utils.SetInternalInt(eid, "hardmod_piercing_count", count)
