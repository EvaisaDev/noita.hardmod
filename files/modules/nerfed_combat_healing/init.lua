local hooks = {}
local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml

ModLuaFileAppend( "data/scripts/perks/perk_pickup.lua", "mods/noita.hardmod/files/modules/perks_trigger_hm_collapse/perk_pickup_append.lua" )

hooks.mod_init = function()
	local path = "data/entities/player_base.xml"
	local xml = nxml.parse(ModTextFileGetContent(path))

	xml:add_child(nxml.parse([[
        <LuaComponent
        _enabled="1"
        script_damage_received="mods/noita.hardmod/files/modules/nerfed_combat_healing/scripts/wound_on_damage.lua"
        execute_every_n_frame="-1"
        >
        </LuaComponent>
    ]]))
	ModTextFileSetContent(path, tostring(xml))

	-- Modular translation injection
	-- local translations_filepath = "mods/noita.hardmod/files/standard.csv"
	-- local translations = ModTextFileGetContent(translations_filepath)
	-- local new_translations = ModTextFileGetContent("mods/noita.hardmod/files/modules/anti_cov_spam/translations.csv")
	-- translations = translations .. "\n" .. new_translations .. "\n"
	-- ModTextFileSetContent(translations_filepath, translations)
end

return hooks --Don't forget to do this if you want your changes to apply!!!!