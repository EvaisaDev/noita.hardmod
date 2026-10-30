local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local x,y = EntityGetTransform(entity_id)


for _,entity in ipairs(EntityGetInRadius(x, y, 90)) do
	if entity ~= root then EntityAddRandomStains(entity, CellFactory_GetType("water"), 1000) end
end