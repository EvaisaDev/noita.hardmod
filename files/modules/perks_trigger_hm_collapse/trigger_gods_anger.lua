if GlobalsGetValue( "TEMPLE_SPAWN_GUARDIAN" ) ~= "1" then
	local x, y = EntityGetTransform( EntityGetWithTag( "player_unit" )[1] )
	GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "1" )
	GamePrintImportant( "$logdesc_temple_spawn_guardian", "" )
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", x, y )
end