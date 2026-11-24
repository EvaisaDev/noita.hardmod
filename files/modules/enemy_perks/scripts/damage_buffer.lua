local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local x,y = EntityGetTransform(entity_id)
local component = GetUpdatedComponentID()

for _,entity in ipairs(EntityGetInRadiusWithTag(x, y, 100, "enemy")) do
	if entity ~= root then
		for _,child in ipairs(EntityGetAllChildren(entity) or {}) do
			if EntityGetName(child) == "hardmod.damage_buff."..component then return end
		end

		local buff = EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/entities/small_damage_buff.xml", x, y)
		EntitySetName(buff, "hardmod.damage_buff."..component)
		EntityAddChild(entity, buff)
	end
end