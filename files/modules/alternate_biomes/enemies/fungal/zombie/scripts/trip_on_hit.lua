local seconds = 80
local tag = "hardmod_trip_on_hit"

local function valid(entity)
	return entity ~= nil and entity ~= 0 and EntityGetIsAlive(entity)
end

local function causes_trip(attacker, projectile)
	if valid(projectile) then
		return EntityHasTag(projectile, tag)
	end
	return valid(attacker) and EntityHasTag(attacker, tag)
end

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	if not causes_trip(entity_thats_responsible, projectile_thats_responsible) then
		return
	end
	local entity_id = GetUpdatedEntityID()
	local ingestion = EntityGetFirstComponentIncludingDisabled(entity_id, "IngestionComponent")
	if ingestion == nil then
		return
	end
	--local stomach = ComponentGetValue2(ingestion, "ingestion_size")
	--EntityIngestMaterial(entity_id, CellFactory_GetType("fungi"), seconds)
	--ComponentSetValue2(ingestion, "ingestion_size", stomach)
end
