print("charm")

local eid = GetUpdatedEntityID()
local x, y = EntityGetTransform(eid)

local function charm_entity(id)
	local effect = GetGameEffectLoadTo(id, "CHARM", true)
	if effect ~= 0 then ComponentSetValue2(effect, "frames", -1) end
end

charm_entity(eid)
EntityRemoveComponent(eid, GetUpdatedComponentID())
EntitySetComponentsWithTagEnabled(eid, "remove_when_defeated", false)

local dmc = EntityGetFirstComponent(eid, "DamageModelComponent")
if dmc then
	ComponentSetValue2(dmc, "hp", 40)
	ComponentSetValue2(dmc, "max_hp", 40)
end

for _,hamis in pairs(EntityGetWithTag("hamis")) do
	charm_entity(hamis)

	local lifetime = EntityGetFirstComponent(hamis, "LifetimeComponent")
	if lifetime then
		EntityRemoveComponent(hamis, lifetime)
	end
end

if not GameHasFlagRun("hardmod_boss_hamis") then
	GameAddFlagRun("hardmod_boss_hamis")
	AddFlagPersistent("hardmod_boss_hamis")

	local drop_x, drop_y = x, y
	local trigger = EntityGetInRadiusWithTag(x, y, 256, "hardmod_hamis_boss_reward")[1]
	if trigger and trigger ~= 0 then
		drop_x, drop_y = EntityGetTransform(trigger)
	end

	EntityLoad("mods/noita.hardmod/files/modules/bosses/gfx/hamis/reward_emitter.xml", drop_x, drop_y)

	-- TODO
	CreateItemActionEntity("HARDMOD_SUMMON_HAMIS", drop_x, drop_y)
end

