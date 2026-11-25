local orig_mark_as_complete = mark_as_complete
function mark_as_complete()
	local eid = GetUpdatedEntityID()
	local x, y = EntityGetTransform(eid)

	orig_mark_as_complete()

	if not EntityHasTag(eid, "statue_hand_3") then
		EntityLoad("data/entities/items/pickup/summon_portal_broken.xml", x + 5, y - 5)
	end

	-- if EntityHasTag(eid, "statue_hand_2") or EntityHasTag(eid, "statue_hand_3") then
	-- end
end
