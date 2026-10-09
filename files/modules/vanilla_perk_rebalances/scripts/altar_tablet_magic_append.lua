---@diagnostic disable: undefined-global

local x, y = EntityGetTransform( GetUpdatedEntityID() )

-- tinker stone becomes TWWE
local wandstone = EntityGetInRadiusWithTag( x, y, 128, "hardmod_wandstone" )[1]
if wandstone ~= nil then
	local sx, sy = EntityGetTransform( wandstone )
	local distance = math.abs( x - sx ) + math.abs( y - sy )

	if distance < 64 then

		-- standard mountain altar feedback
		EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", tx, ty)
		GamePrintImportant( "$log_altar_magic" )

		-- spawn the perk
	    dofile_once( "data/scripts/perks/perk.lua" )
		perk_spawn( sx, sy - 10, "EDIT_WANDS_EVERYWHERE" )

		-- destroy the stone
		EntityKill( wandstone )
	end
end
