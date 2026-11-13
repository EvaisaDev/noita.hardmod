function item_pickup(item, owner, name)
	for _,child in ipairs(EntityGetAllChildren(owner) or {}) do
		if EntityGetName(child) == "hardmod.wounded_effect" then
			EntityKill(child) return
		end
	end
end