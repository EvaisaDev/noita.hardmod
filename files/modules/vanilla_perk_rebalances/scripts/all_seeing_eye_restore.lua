dofile_once( "mods/noita.hardmod/lib/utilities.lua" )

EntitySetComponentsWithTagEnabled( GetUpdatedEntityID(), "fog_of_war_hole", true )
SetInternalInt( GetUpdatedEntityID(), "hardmod_wizard_dark_counter", 0 )
GamePrint( "Your All-Seeing Eye has been restored." )
