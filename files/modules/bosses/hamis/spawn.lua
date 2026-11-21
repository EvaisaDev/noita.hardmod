function collision_trigger()
	local eid = GetUpdatedEntityID()
	local x, y = EntityGetTransform(eid)

	EntityLoad("mods/noita.hardmod/files/modules/bosses/hamis/entity/boss.xml", x, y)
	EntityLoad("data/entities/particles/image_emitters/magical_symbol_fast.xml", x, y)

	EntityKill(eid)
end
