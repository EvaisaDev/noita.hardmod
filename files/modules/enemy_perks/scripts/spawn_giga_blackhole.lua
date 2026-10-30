function death(damage_type_bit_field, message, attacker, drop_items)
	local x,y = EntityGetTransform(GetUpdatedEntityID())
	EntityLoad("data/entities/projectiles/deck/black_hole_big.xml", x, y)
end