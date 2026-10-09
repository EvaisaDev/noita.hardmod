
local old_death = death
function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	old_death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )

	-- Master Of Masters now drops TWWE on death
    dofile_once( "data/scripts/perks/perk.lua" )
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
	perk_spawn( x, y, "EDIT_WANDS_EVERYWHERE" )
end