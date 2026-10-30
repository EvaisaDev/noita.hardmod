local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml

biome_data_table = biome_data_table or {}
biome_ui_names = biome_ui_names or {}

local function string_starts(str, start)
  return string.sub(str, 1, #start) == start
end

local function get_biome_data(path)
  local file = nxml.parse_file(path)
  local topology = file:first_of("Topology")
  if not topology then return end

  return topology:get("name")
end

function GetBiomeTableFromKeys(tbl)
  if #biome_data_table > 0 then return end

  local biomes = {}
  for key,_ in pairs(tbl) do
	table.insert(biomes, key)
  end

  for _,biome in pairs(biomes) do
    local path = biome
    if not string_starts(path, "data/") and not string_starts(path, "mods/") then
      path = "data/biome/"..biome..".xml"
    end

    local name = get_biome_data(path) or "_EMPTY_"

    biome_data_table[biome] = {
      path = path,
      ui_name = name
    }

    biome_ui_names[name] = biome
  end
end
