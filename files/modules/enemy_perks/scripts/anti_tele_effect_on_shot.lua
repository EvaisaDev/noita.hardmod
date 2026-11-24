local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local RADIUS = 220

-- ty Lamia
function shot(projectile)
	local entity_id = GetUpdatedEntityID()
	--BACKWARDS COMPATIBILITY, LUACOMP USED TO BE DIRECTLY ON PLAYER
	if EntityHasTag(entity_id, "player_unit") then
		EntityRemoveComponent(entity_id, GetUpdatedComponentID())
		return
	end

	--redefine here cuz callbacks are fuckin' jank
	entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)
	local aura = EntityGetClosestWithTag(x, y, "hardmod_anti_tele_aura")
	if aura == 0 then EntityKill(entity_id) return end
	local ax, ay = EntityGetTransform(aura)
	if not x or not ax then return end -- ok sure

	if utils.get_distance(x, y, ax, ay) > RADIUS then EntityKill(entity_id) return end

	local delete_proj = false

	--Grabs a list of all TeleportProjectileComponents and disables them
	local comps = EntityGetComponentIncludingDisabled(projectile, "TeleportProjectileComponent")
	for _,v in pairs(comps or {}) do
		EntityRemoveComponent(projectile, v)
		delete_proj = true
	end

	--Grabs a list of all Swapper Components and disables them
	local fxcomps = EntityGetComponentIncludingDisabled(projectile, "HitEffectComponent")
	for _,v in pairs(fxcomps or {}) do
		if ComponentGetValue2(v, "effect_hit") == "SWAPPER" then
			EntityRemoveComponent(projectile, v)
			delete_proj = true
		end
	end

	--Disables RGB Portals from teleporting you
	EntitySetComponentsWithTagEnabled(projectile, "apotheosis_blob_boss", false)

	if delete_proj then
		EntityKill(projectile)
	end
end
