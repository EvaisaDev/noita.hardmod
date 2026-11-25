local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml

local root = "mods/noita.hardmod/files/modules/core/"

ModLuaFileAppend("data/scripts/gun/gun.lua", root.."appends/gun.lua")
ModLuaFileAppend("data/scripts/biome_scripts.lua", root.."appends/biome_scripts.lua")

-- remove perks with not_progress from progress menu
utils.patchifile("data/scripts/perks/perk_reflect.lua", {{
	from = [[
		RegisterPerk(
			perk.id,
			perk.ui_name,
			perk.ui_description,
			perk.ui_icon,
			perk.perk_icon
		)
	]],
	insert_before = [[
		if not perk.not_progress then
	]],
	insert_after = [[
		end
	]],
}})

if ModIsEnabled("Apotheosis") then
	utils.modifile(
		"mods/Apotheosis/files/scripts/perks/custom_perks.lua",
		[[do c = perk_list[z]],
		[[do local c = perk_list[z]]
	)
end

-- don't mind this
local helpless_death = root.."scripts/misc/helpless_death.lua"
local track_animals = { "longleg.xml", "fish.xml" }

ModLuaFileAppend("data/scripts/animals/helpless_death.lua", helpless_death)

for _,animal in pairs(track_animals) do
	for file in nxml.edit_file("data/entities/animals/"..animal) do
		file:create_child("LuaComponent", { script_death = helpless_death })
	end
end

return {}
