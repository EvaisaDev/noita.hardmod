function death(damage_type_bit_field, message, attacker, drop_items)
	local x,y = EntityGetTransform(GetUpdatedEntityID())
	SetRandomSeed(x-219, y+191873)
	for _=1, Random(1,3) do
		EntityLoad("data/entities/animals/skullfly.xml", x, y)
	end
end
