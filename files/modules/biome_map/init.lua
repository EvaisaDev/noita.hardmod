local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua")---@type nxml

local custom_biomes = {
  { h = 2, color = "ffde88e3", file = "secret_lab_path.xml" },
  { h = 0, color = "ffff56a5", file = "pw_barrier.xml" },
  { h = 0, color = "ffffe098", file = "cheese/biome.xml" },
}

for file in nxml.edit_file("data/biome/_biomes_all.xml") do
	for _,biome in pairs(custom_biomes) do
		file:create_child("Biome", {
			biome_filename = "mods/noita.hardmod/files/modules/biome_map/biome/" .. biome.file,
			height_index = biome.h,
			color = biome.color
		})
	end
end

for file in nxml.edit_file("data/biome/_pixel_scenes.xml") do
	local ps = file:first_of("PixelSceneFiles")
	if not ps then break end

	for entry in ps:each_child() do
		local path = ""
		for i=1,#entry.content,1 do
			path = path .. entry.content[i]
		end

		if path == "data/biome_impl/spliced/lavalake_pit_bottom.xml" then
			ps:remove_child(entry)
		end
	end
end

ModMagicNumbersFileAdd("mods/noita.hardmod/files/modules/biome_map/magic_numbers.xml")
utils.modifile(
  "data/scripts/biomes/snowcastle_cavern.lua",
  [[local is_right = ]],
  [[local is_right = true --]]
)

ModMaterialsFileAdd("mods/noita.hardmod/files/modules/biome_map/materials.xml")

return {}
