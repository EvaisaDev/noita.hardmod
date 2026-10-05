dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk.lua" )

local old_item_pickup = item_pickup
function item_pickup( entity_item, entity_who_picked, item_name )
	local kill_other_perks = true

	local components = EntityGetComponent( entity_item, "VariableStorageComponent" )
	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "perk_dont_remove_others") then
				if( ComponentGetValueBool( comp_id, "value_bool" ) ) then
					kill_other_perks = false
				end
			end
		end
	end

	if kill_other_perks then
		local px, py = EntityGetTransform( entity_who_picked )
		local exit = EntityGetInRadiusWithTag( px, py, 300, "workshop_exit" )[1]
		if exit ~= nil then
			local ctcomp = EntityGetFirstComponentIncludingDisabled( exit, "CollisionTriggerComponent" )

			if ctcomp ~= nil then
				-- EntitySetTransform( exit, px - 30, py - 60 )
				-- @UserK uncomment the line above + experiment with the offset for shop tunnel collapse

				ComponentSetValue2( ctcomp, "width", 512 )
				ComponentSetValue2( ctcomp, "height", 512 )
				ComponentSetValue2( ctcomp, "radius", 512 ) -- :]
			end
		end

		local perk_aura = EntityGetInRadiusWithTag( px, py, 300, "hardmod_perk_aura" )[1]
		if perk_aura then
			EntityKill( perk_aura )
		end
	end

	perk_pickup( entity_item, entity_who_picked, item_name, true, kill_other_perks )
end
