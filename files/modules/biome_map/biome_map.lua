local file = "mods/noita.hardmod/files/modules/biome_map/gfx/biome_map_altered.png"
local width = 72
local height = 48

if ModIsEnabled("Apotheosis") then
	file = "mods/noita.hardmod/files/modules/biome_map/cross_mod_compat/biome_map_apotheosis_merged.png"
	width = 102
	height = 48
end

BiomeMapSetSize(width, height)
BiomeMapLoadImage(0, 0, file)

