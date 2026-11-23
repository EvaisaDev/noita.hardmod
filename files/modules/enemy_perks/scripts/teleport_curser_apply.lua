local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)

local initial_time = 60

for _,child in ipairs(EntityGetAllChildren(root) or {}) do
	local name = EntityGetName(child)
	if name == "hardmod.teleporting" then
		local gec = EntityGetFirstComponent(child, "GameEffectComponent")
		if not gec then return end
		ComponentSetValue2(gec, "frames", initial_time)
		EntityKill(entity_id) return
	end
end

local x,y = EntityGetTransform(entity_id)
local effect = EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/entities/teleport_curser_effect.xml", x, y)
EntityAddChild(root, effect)
local gec = EntityGetFirstComponent(effect, "GameEffectComponent")
if gec then ComponentSetValue2(gec, "frames", initial_time) end