local entity_id = GetUpdatedEntityID()

function damage_received(damage, message, attacker, is_fatal)
	local x,y = EntityGetTransform(entity_id)
	if damage <= 0 then return end
	for _,entity in ipairs(EntityGetInRadius(x, y, 70)) do
		if entity ~= entity_id then
			EntityInflictDamage(entity, -damage, "DAMAGE_HEALING", "recycled health", "NONE", 0, 0)
			local ex,ey = EntityGetTransform(entity)
			EntityLoad("data/entities/particles/heal_effect.xml", ex, ey)
		end
	end
end