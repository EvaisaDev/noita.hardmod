local entity_id = GetUpdatedEntityID()

local found
for _,eid in ipairs(EntityGetInRadius(0, 0, 3)) do
    if EntityGetName(eid) == "hardmod.enemy_perks" then
        found = true
    end
end

local spr_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
if not spr_comp then return end

EntitySetComponentIsEnabled(entity_id, spr_comp, found)