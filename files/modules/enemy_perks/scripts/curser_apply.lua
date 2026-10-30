local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)

for _,child in ipairs(EntityGetAllChildren(root) or {}) do
	local name = EntityGetName(child)
	print(name)
	if name == "hardmod.curse_cloud_thunder" or name == "hardmod.curse_cloud_acid" then
		return
		-- local gec = EntityGetFirstComponent(child, "GameEffectComponent")
		-- if not gec then return end
		-- print("adding to lifetime...")
		-- ComponentSetValue2(gec, "frames", ComponentGetValue2(gec, "frames") + 600)
		-- EntityKill(entity_id) return
	end
end

print("adding new effect...")
local x,y = EntityGetTransform(entity_id)
EntityAddChild(root, EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/entities/curser_effect.xml", x, y))
