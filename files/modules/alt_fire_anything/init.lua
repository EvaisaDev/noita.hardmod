local hooks = {}

hooks.mod_post_init = function()
	ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/noita.hardmod/files/modules/alt_fire_anything/scripts/actions_append.lua" )
	ModLuaFileAppend( "data/scripts/gun/gun.lua", "mods/noita.hardmod/files/modules/alt_fire_anything/scripts/gun_append.lua" )
end

return hooks --Don't forget to do this if you want your changes to apply!!!!