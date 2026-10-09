local hooks = {}
local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml

-- xml modifications as separate functions for better readability
local function modify_wandstone()
	local path = "data/entities/items/pickup/wandstone.xml"
	for content in nxml.edit_file( path ) do
        content:set( "tags", content:get( "tags" ) .. ",hardmod_wandstone" )
    end
end

local function modify_mountain_altar()
	local path = "data/entities/animals/boss_centipede/ending/ending_sampo_spot_mountain.xml"
	local xml = nxml.parse( ModTextFileGetContent( path ) )
	xml:add_child( nxml.parse( [[
        <LuaComponent
        _enabled="1"
        script_source_file="mods/noita.hardmod/files/modules/vanilla_perk_rebalances/scripts/altar_tablet_magic_append.lua"
        execute_every_n_frame="240"
        >
        </LuaComponent>
    ]] ))
	ModTextFileSetContent( path, tostring( xml ) )
end

hooks.mod_init = function()
	modify_wandstone()
	modify_mountain_altar()
end

hooks.mod_post_init = function()
	ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/scripts/perks_append.lua")
	ModLuaFileAppend("data/entities/animals/boss_wizard/death.lua", "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/scripts/boss_wizard_death_append.lua")
	-- ModLuaFileAppend("data/scripts/magic/altar_tablet_magic.lua", "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/scripts/altar_tablet_magic_append.lua")
end

return hooks --Don't forget to do this if you want your changes to apply!!!!