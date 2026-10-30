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
	for _,comp in ipairs(EntityGetComponent(GetUpdatedEntityID(), comp_id) or {}) do
		for _,value in ipairs(values) do
			ComponentSetValue2(comp, value, ComponentGetValue2(comp, value) / 1.2)
		end
	end
end