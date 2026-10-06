
local old_spawn_all_perks = spawn_all_perks
function spawn_all_perks( x, y )
	old_spawn_all_perks( x, y )
	EntityLoad( "mods/noita.hardmod/files/modules/perks_trigger_hm_collapse/entities/perk_altar_aura.xml", x + 30, y + 10 )
end
