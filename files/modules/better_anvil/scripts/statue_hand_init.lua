local eid = GetUpdatedEntityID()
local phys = EntityGetFirstComponent(eid, "PhysicsImageShapeComponent")

if not phys then return end

local x, y = EntityGetTransform(eid)
SetRandomSeed(x, y)
local num = Random(1, 3)

ComponentSetValue2(phys, "image_file", "data/buildings_gfx/statue_hand_"..num..".png")
