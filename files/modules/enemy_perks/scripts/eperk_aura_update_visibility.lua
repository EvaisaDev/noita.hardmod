local utils = dofile_once( "mods/noita.hardmod/lib/utilities.lua" ) ---@type utils

local aura = GetUpdatedEntityID()
local x, y = EntityGetTransform(aura)
local owner = EntityGetRootEntity(aura)
if not owner then return end
if not utils.GetInternalBool(owner, "hardmod_hide_eperk_auras") then
	EntitySetComponentsWithTagEnabled(aura, "aura_can_be_invis", true)
	return
end

local pec = EntityGetFirstComponentIncludingDisabled(aura, "ParticleEmitterComponent")
local _,aura_radius = ComponentGetValue2(pec, "area_circle_radius")

local nearby_players = EntityGetInRadiusWithTag( x, y, aura_radius, "player_unit" )
EntitySetComponentsWithTagEnabled(aura, "aura_can_be_invis", nearby_players and #nearby_players > 0)
