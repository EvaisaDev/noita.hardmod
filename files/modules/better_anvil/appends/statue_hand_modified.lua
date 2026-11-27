function mark_as_complete()
	local eid = GetUpdatedEntityID()
	local x, y = EntityGetTransform(eid)

	local count = tonumber(GlobalsGetValue("statue_hands_destroyed")) or 0
	count = math.min(count + 1, 8)

	EntityLoad("data/entities/items/pickup/summon_portal_broken.xml", x, y - 5)
	EntityLoad("data/entities/buildings/statue_hand_fx.xml", x, y)
	EntityKill(eid)

	for i=1,count do
		EntityLoad("data/entities/animals/monk.xml", x + i%2*4, y - (i-1) * 10)
	end

	GlobalsSetValue("statue_hands_destroyed", tostring(count))
end
