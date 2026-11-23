local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local entity_id = GetUpdatedEntityID()

--BACKWARDS COMPATIBILITY, LUACOMP USED TO BE DIRECTLY ON PLAYER
if EntityHasTag(entity_id, "player_unit") then
	EntityRemoveComponent(entity_id, GetUpdatedComponentID())
	return
end

local RADIUS = 220

local x, y = EntityGetTransform(entity_id)
local aura = EntityGetClosestWithTag(x, y, "hardmod_anti_tele_aura")
if aura == 0 then EntityKill(entity_id) return end
local ax, ay = EntityGetTransform(aura)

if utils.get_distance(x, y, ax, ay) > RADIUS then EntityKill(entity_id) return end