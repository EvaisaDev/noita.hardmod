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

ModMagicNumbersFileAdd("mods/noita.hardmod/files/modules/biome_map/magic_numbers.xml")
utils.modifile(
  "data/scripts/biomes/snowcastle_cavern.lua",
  [[local is_right = ]],
  [[local is_right = true --]]
)

ModMaterialsFileAdd("mods/noita.hardmod/files/modules/biome_map/materials.xml")

return {}
