local adcomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "AreaDamageComponent" )
if adcomp ~= nil then
	ComponentSetValue2( adcomp, "damage_per_frame", 0.01333 )
end
