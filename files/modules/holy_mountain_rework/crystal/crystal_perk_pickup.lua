function item_pickup(item, taker, name)
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform(entity_id)
	local self_path = ComponentGetValue2(GetUpdatedComponentID(), "script_item_picked_up")

	--GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/invisibility/deactivate", x, y)
	GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/shop_item/create", x, y)

	local fragile_perks = {}
	for _,perk in ipairs(EntityGetInRadiusWithTag(x, y, 1000, "item_perk")) do
		if perk == entity_id then goto continue end
		for _,luacomp in ipairs(EntityGetComponent(perk, "LuaComponent") or {}) do
			if ComponentGetValue2(luacomp, "script_item_picked_up") == self_path then
				fragile_perks[#fragile_perks+1] = perk
				goto continue
			end
		end
		::continue::
	end

	for i = #fragile_perks, 2, -1 do
		local j = math.random(i)
		fragile_perks[i], fragile_perks[j] = fragile_perks[j], fragile_perks[i]
	end

	for i=1,math.ceil(#fragile_perks*1/3) do
		local destroy_perk = fragile_perks[i]
		local px, py = EntityGetTransform(destroy_perk)
		EntityLoad("mods/noita.hardmod/files/modules/holy_mountain_rework/crystal/perk_destroyed.xml", px, py)
		EntityKill(destroy_perk)
	end
end