local entity_id = GetUpdatedEntityID()
local component = GetUpdatedComponentID()

if not ComponentGetValue2(component, "limit_all_callbacks") then
	ComponentSetValue2(component, "limit_all_callbacks", true)

	local component_damage_fuckin_uhhhhh___stuff = {
		AnimalAIComponent = {
			"attack_melee_damage_min",
			"attack_melee_damage_max",
			"attack_dash_damage"
		},
		WormComponent = {
			"bite_damage"
		},
	}
	for comp_id,values in pairs(component_damage_fuckin_uhhhhh___stuff) do
		for _,comp in ipairs(EntityGetComponent(entity_id, comp_id) or {}) do
			for _,value in ipairs(values) do
				ComponentSetValue2(comp, value, ComponentGetValue2(comp, value) * 1.2)
			end
		end
	end
end

function shot(projectile)
	for _,proj_comp in ipairs(EntityGetComponentIncludingDisabled(projectile, "ProjectileComponent") or {}) do
		ComponentSetValue2(proj_comp, "damage", ComponentGetValue2(proj_comp, "damage") * 1.2)
		for key, value in pairs(ComponentObjectGetMembers(proj_comp, "damage_by_type") or {}) do
			ComponentObjectSetValue2(proj_comp, key, value * 1.2)
		end
		ComponentObjectSetValue2(proj_comp, "config_explosion", "damage", ComponentObjectSetValue2(proj_comp, "config_explosion", "damage") * 1.2)
		ComponentObjectSetValue2(proj_comp, "config_explosion", "explosion_radius", ComponentObjectSetValue2(proj_comp, "config_explosion", "explosion_radius") * 1.2)
	end
end

local x,y = EntityGetTransform(entity_id)
for _,enemy in ipairs(EntityGetInRadiusWithTag(x, y, 100, "hardmod.blessed")) do
	local enemy_perks_handler
	for _,child in ipairs(EntityGetAllChildren(enemy) or {}) do
		if EntityGetName(child) == "hardmod.enemy_perks" then
			for _,varcomp in ipairs(EntityGetComponent(enemy_perks_handler, "VariableStorageComponent") or {}) do
				if ComponentGetValue2(varcomp, "name") == "enemy_perk_data" then
					if (","..ComponentGetValue2(varcomp, "value_string")..","):find(",damage_buffer,") then
						return
					end
				end
			end
		end
	end
end

EntityKill(entity_id)