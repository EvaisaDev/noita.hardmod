local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

-- when the ring breaks, create the portal
function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local ring = GetUpdatedEntityID()
	local x, y = EntityGetTransform( ring )
	local portal = EntityLoad( "mods/noita.hardmod/files/modules/ring_of_returning/entities/return_portal.xml", x, y )

	if portal ~= nil then
		local tele_comp = EntityGetFirstComponentIncludingDisabled( portal, "TeleportComponent" )
		if tele_comp ~= nil then
			local tx, ty = 766, -808

			local players = EntityGetWithTag( "player_unit" )
			if players ~= nil then
				for i,player in ipairs( players ) do
					local stored_x = utils.GetInternalInt( player, "hardmod_return_portal_dest_x" )
					local stored_y = utils.GetInternalInt( player, "hardmod_return_portal_dest_y" )
					if stored_x ~= nil and stored_y ~= nil then
						tx = stored_x
						ty = stored_y
						break
					end
				end
				
				ComponentSetValue2( tele_comp, "target", tx, ty )
			end
		end
	end
end
