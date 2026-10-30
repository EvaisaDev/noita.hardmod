local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local x,y = EntityGetTransform(entity_id)


for _,entity in ipairs(EntityGetInRadiusWithTag(x, y, 100, "enemy")) do
	if entity ~= root then
		for _,child in ipairs(EntityGetAllChildren(entity) or {}) do
			if EntityGetName(child) == "hardmod.damage_buff" then return end
		end
		EntityAddChild(entity, EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/entities/small_damage_buff.xml", x, y))
	end
end