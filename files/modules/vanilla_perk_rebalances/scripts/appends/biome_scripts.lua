if not RegisterSpawnFunction then print("missing RegisterSpawnFunction") return end

RegisterSpawnFunction(0xfffacc68, "spawn_hardmod_level_shop")

function HardmodGenerateLevelShop(x, y, min_spells)
	local count = (tonumber(GlobalsGetValue("PERK_PICKED_EXTRA_SHOP_ITEM_PICKUP_COUNT")) or 0) + min_spells
	local total_width = 23 * (min_spells - 1)
	local spacing = total_width / (count - 1)

	-- print("spawning", count, "spells at", x, y, "with spacing", spacing)

	for _=1,count do
		generate_shop_item(x, y, false, nil)
		x = x + spacing
	end
end

function spawn_hardmod_level_shop(x, y)
	HardmodGenerateLevelShop(x + 3, y, 5)
end
