local min_boss_hp = 2 / 25

function damage_about_to_be_received(damage)
	if damage < 0 then return 0, 0 end

	local eid = GetUpdatedEntityID()

	local dmc = EntityGetFirstComponent(eid, "DamageModelComponent")
	if not dmc then return 0, 0 end

	local hp = ComponentGetValue2(dmc, "hp")
	if hp <= min_boss_hp then
		ComponentSetValue2(dmc, "hp", min_boss_hp)
		return min_boss_hp - 0.01, 0
	end

	return math.min(damage * 0.5, hp * 0.5), 0
end
