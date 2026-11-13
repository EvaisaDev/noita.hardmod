local duration_per_percent = 120
local duration_instance_cap = 600 --Maximum duration of wounded in seconds that can be gained from a single instance of damage. (ie if the player takes 50% of their health as damage they should gain 100 seconds of wounded, but this would cap it at 10 seconds)
local duration_cap = 1200 --Upper limit in seconds that the wounded status gained from taking damage can be


function damage_received(damage, message, attacker, is_fatal)
	if damage <= 0 then return end
	if not ComponentGetIsEnabled(GetUpdatedComponentID()) then return end

	local entity_id = GetUpdatedEntityID()
	local dmc = EntityGetFirstComponent(entity_id, "DamageModelComponent")
	if not dmc then return end

	local max_hp = ComponentGetValue2(dmc, "max_hp")
	local perc = max_hp * .01
	local add_duration = math.min(duration_instance_cap,math.floor(damage / perc) * duration_per_percent)
	if add_duration <= 0 then return end

	for _,child in ipairs(EntityGetAllChildren(entity_id) or {}) do
		if EntityGetName(child) == "hardmod.wounded_effect" then
			local gec = EntityGetFirstComponentIncludingDisabled(child, "GameEffectComponent")
			if gec then
				ComponentSetValue2(gec, "frames", math.min(duration_cap, ComponentGetValue2(gec, "frames") + add_duration))
				return
			end
		end
	end

	local x,y = EntityGetTransform(entity_id)
	local wounded_effect = EntityLoad("mods/noita.hardmod/files/modules/nerfed_combat_healing/wounded_effect.xml", x, y)
	EntityAddChild(entity_id, wounded_effect)
	local gec = EntityGetFirstComponentIncludingDisabled(wounded_effect, "GameEffectComponent")
	if gec then ComponentSetValue2(gec, "frames", add_duration) end
end