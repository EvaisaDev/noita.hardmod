dofile_once( "mods/noita.hardmod/lib/utilities.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )

local ACTIVATION_THRESHOLD = 8
local EFFECT_DURATION = 1200

local ase_entity = EntityGetInRadiusWithTag( x, y, 16, "hardmod_all_seeing_eye_entity" )[1]
if ase_entity ~= nil then
	if GetInternalInt( ase_entity, "hardmod_wizard_dark_counter", true ) < ACTIVATION_THRESHOLD then
		RaiseInternalInt( ase_entity, "hardmod_wizard_dark_counter", 1 )
	elseif GetInternalInt( ase_entity, "hardmod_wizard_dark_counter" ) < ACTIVATION_THRESHOLD + 1 then
		EntitySetComponentsWithTagEnabled( ase_entity, "fog_of_war_hole", false )
		EntityAddComponent2( ase_entity, "LuaComponent", {
			script_source_file = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/scripts/all_seeing_eye_restore.lua",
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
		SetInternalInt( ase_entity, "hardmod_wizard_dark_counter", ACTIVATION_THRESHOLD + 1 )
	end
else
	ase_entity = EntityGetWithTag( "hardmod_all_seeing_eye_entity" )[1]
	if ase_entity ~= nil and GetInternalInt( ase_entity, "hardmod_wizard_dark_counter" ) < ACTIVATION_THRESHOLD + 1 then
		SetInternalInt( ase_entity, "hardmod_wizard_dark_counter", 0 )
	end
end