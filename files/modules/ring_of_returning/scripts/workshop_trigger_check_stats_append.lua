local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local _collision_trigger = collision_trigger
function collision_trigger()
	_collision_trigger()

	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	local reference_id = EntityGetClosestWithTag( x, y, "workshop_reference" )
	if( GlobalsGetValue( "TEMPLE_SPAWN_GUARDIAN" ) ~= "0" ) and ( GlobalsGetValue( "TEMPLE_PEACE_WITH_GODS" ) == "0" ) then return end

	local sx,sy = x,y
	if reference_id ~= NULL_ENTITY then
		sx,sy = EntityGetTransform( reference_id )
	else
		print( "No reference point found for Ring of Returning (Hardmod)" )
	end
	EntityLoad( "mods/noita.hardmod/files/modules/ring_of_returning/entities/ring_of_returning.xml", sx, sy - 20 )

	local nearby_players = EntityGetWithTag( "player_unit" )
	if nearby_players ~= nil then
		for i,player in ipairs( nearby_players ) do
			utils.SetInternalInt( player, "hardmod_return_portal_dest_x", sx )
			utils.SetInternalInt( player, "hardmod_return_portal_dest_y", sy )
		end
	end
end
