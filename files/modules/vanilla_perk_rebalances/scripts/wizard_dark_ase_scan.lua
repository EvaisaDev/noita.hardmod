local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local wiz = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local ACTIVATION_THRESHOLD = 6
local EFFECT_DURATION = 1200

local ase_entity = EntityGetInRadiusWithTag( x, y, 16, "hardmod_all_seeing_eye_entity" )[1]
if ase_entity ~= nil then
	local wizard_dark_counter = utils.GetInternalInt( wiz, "hardmod_wizard_dark_counter" ) or 0
	if wizard_dark_counter < ACTIVATION_THRESHOLD then
		utils.SetInternalInt( wiz, "hardmod_wizard_dark_counter", wizard_dark_counter + 1 )
	elseif wizard_dark_counter < ACTIVATION_THRESHOLD + 1 then
		EntitySetComponentsWithTagEnabled( ase_entity, "fog_of_war_hole", false )
		EntityAddComponent2( ase_entity, "LuaComponent", {
			script_source_file = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/scripts/perks/all_seeing_eye_restore.lua",
			execute_on_added = false,
			execute_every_n_frame = EFFECT_DURATION,
			remove_after_executed = true
		} )

		local player_id = EntityGetRootEntity( ase_entity )
		local px, py = EntityGetTransform( player_id )
        local child_id = EntityLoad( "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/status_effects/ase_disabled.xml", 0, 0 )
        EntityAddComponent2( child_id, "GameEffectComponent", {
            effect = "NONE",
            frames = EFFECT_DURATION
        })
        EntityAddChild( player_id, child_id )
        
		GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/blindness/create", px, py )
		GamePrint( "Your All-Seeing Eye was temporarily disabled!" )
		utils.SetInternalInt( wiz, "hardmod_wizard_dark_counter", ACTIVATION_THRESHOLD + 1 )

        -- tag the wiz so their counter can be remotely reset after 20 sec
        if not EntityHasTag( wiz, "hardmod_master_of_blinding" ) then
        	EntityAddTag( wiz, "hardmod_master_of_blinding" )
        end
	end
else
	ase_entity = EntityGetWithTag( "hardmod_all_seeing_eye_entity" )[1]
	if ase_entity ~= nil and utils.GetInternalInt( wiz, "hardmod_wizard_dark_counter", true ) < ACTIVATION_THRESHOLD + 1 then
		utils.SetInternalInt( wiz, "hardmod_wizard_dark_counter", 0 )
	end
end
