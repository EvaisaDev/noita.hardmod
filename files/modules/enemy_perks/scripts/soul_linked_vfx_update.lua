-- most of this code was shamelessly stolen from Apoth pylons
dofile_once("data/scripts/lib/utilities.lua")
local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity(entity_id)
local x, y = EntityGetTransform(owner)

local ally = utils.GetInternalInt(owner, "hardmod_soul_linked_ally") or 0

-- TODO: wtf do i do instead of this
---@diagnostic disable-next-line: cast-type-mismatch
---@cast ally entity_id

if ally == 0 or not EntityGetIsAlive(ally) then return end
local children = EntityGetAllChildren(entity_id)
if children == nil or #children == 0 then return end

-- "shoulder" position
local ax, ay = EntityGetTransform(ally)
local offset_y = 0
for _,hitbox in ipairs(EntityGetComponent(ally, "HitboxComponent") or {}) do
	offset_y = math.max(offset_y, -0.5 * ComponentGetValue2(hitbox, "aabb_min_y"))
end
ay = ay + offset_y

for _,fx_entity in pairs(children) do
	if EntityHasTag(fx_entity, "arm_fx") then
		local pos = ProceduralRandomf(GameGetFrameNum(), fx_entity)

		local tx, ty = vec_lerp(ax, ay, x, y, pos)
		EntitySetTransform(fx_entity, tx, ty)
	end
end
