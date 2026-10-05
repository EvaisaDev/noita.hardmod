local hooks = {}
local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml

ModLuaFileAppend("data/scripts/biomes/temple_altar.lua", "mods/noita.hardmod/files/modules/perks_trigger_hm_collapse/temple_altar_append.lua")

hooks.mod_init = function()
	local path = "data/entities/buildings/workshop_exit.xml"
	local xml = nxml.parse(ModTextFileGetContent(path))
	local ctcomp = xml:first_of("CollisionTriggerComponent")
	if ctcomp then
		ctcomp:set("width", 0)
		ctcomp:set("height", 0)
		ctcomp:set("radius", 0)
	end
	ModTextFileSetContent(path, tostring(xml))

	local path = "data/entities/buildings/workshop_exit.xml"
	local xml = nxml.parse(ModTextFileGetContent(path))
	local ctcomp = xml:first_of("CollisionTriggerComponent")
	if ctcomp then
		ctcomp:set("width", 0)
		ctcomp:set("height", 0)
		ctcomp:set("radius", 0)
	end
	ModTextFileSetContent(path, tostring(xml))

	path = "data/entities/misc/workshop_areadamage.xml"
	xml = nxml.parse(ModTextFileGetContent(path))
	local adcomp = xml:first_of("AreaDamageComponent")
	if adcomp then
		adcomp:set("damage_per_frame", 0)  -- delay the area's curse damage by 2.5s
	end
	local ltcomp = xml:first_of("LifetimeComponent")
	if ltcomp then
		ltcomp:set("lifetime", 1240 + 150)
	end
	xml:add_child(nxml.parse([[
        <LuaComponent
        _enabled="1"
        script_source_file="mods/noita.hardmod/files/modules/perks_trigger_hm_collapse/workshop_areadamage_enable.lua"
        execute_every_n_frame="150"
        execute_times="1"
        execute_on_added="0"
        remove_on_executed="1"
        >
        </LuaComponent>
    ]]))
	-- xml:add_child(nxml.parse([[
    --     <LuaComponent
    --     _enabled="1"
    --     script_source_file="mods/noita.hardmod/files/modules/perks_trigger_hm_collapse/trigger_gods_anger.lua"
    --     execute_every_n_frame="300"
    --     execute_times="1"
    --     execute_on_added="0"
    --     remove_on_executed="1"
    --     >
    --     </LuaComponent>
    -- ]]))
	ModTextFileSetContent(path, tostring(xml))
end

hooks.player_spawned = function()
	EntitySetTransform( EntityGetWithTag("player_unit")[1], -62, 1345 )
end

return hooks --Don't forget to do this if you want your changes to apply!!!!