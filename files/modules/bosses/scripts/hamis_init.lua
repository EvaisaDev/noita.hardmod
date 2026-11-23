local eid = GetUpdatedEntityID()
EntityAddTag(eid, "hamis")

if not GameHasFlagRun("hardmod_boss_hamis") then return end

EntitySetComponentsWithTagEnabled(eid, "enabled_if_charmed", true)

local charm = GetGameEffectLoadTo(eid, "CHARM", true)
if charm then
	ComponentSetValue2(charm, "frames", -1)
end
