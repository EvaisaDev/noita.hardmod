local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

--dont mess with stuff if its more than 20px off-screen
local lee = 20
local cx,cy, cw, ch = GameGetCameraBounds()
if not ((cx-lee)< x and x < (cx+cw+lee)
    and (cy-lee)< y and y < (cy+ch+lee)) then
    return
end


--Keep these consistent with handler.lua
local y_offset_amount = 14
local stack_fade_amount = 0.2
local stack_offset_amount = 2

local root = EntityGetRootEntity(entity_id)
if entity_id == root or not EntityGetIsAlive(root) then EntityKill(entity_id) return end

local offset_y = 0
for _,hitbox in ipairs(EntityGetComponent(root, "HitboxComponent") or {}) do
	offset_y = math.max(offset_y, -ComponentGetValue2(hitbox, "aabb_min_y"))
end
offset_y = offset_y + y_offset_amount
for _,spr_comp in ipairs(EntityGetComponent(entity_id, "SpriteComponent") or {}) do
    if ComponentGetValue2(spr_comp, "offset_y") == offset_y then return end --cancel if no changes to hitbox size
    local offset = offset_y
        - stack_offset_amount
        * (1-ComponentGetValue2(spr_comp, "alpha")) / stack_fade_amount
    ComponentSetValue2(spr_comp, "offset_y", offset)
end