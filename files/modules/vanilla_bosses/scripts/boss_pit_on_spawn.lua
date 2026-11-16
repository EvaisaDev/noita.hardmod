local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local shield = EntityLoad( "mods/noita.hardmod/files/modules/vanilla_bosses/entity/gold_shield_squiddy.xml", x, y )
EntityAddChild( entity_id, shield )
EntitySetComponentsWithTagEnabled( shield, "hardmod_gold_shield_active", false )
EntitySetComponentsWithTagEnabled( shield, "hardmod_gold_shield_inactive", true )

EntityAddComponent2( entity_id, "LuaComponent", {
	_tags = "perk_component,hardmod_gold_shield",
	script_damage_received = "mods/noita.hardmod/files/modules/vanilla_bosses/scripts/perks/gold_shield_on_damage.lua",
	execute_every_n_frame = -1,
})

-- give squidward one of a select few late-game eperks
dofile_once( "data/scripts/lib/utilities.lua" )
local biome_index = dofile_once("mods/noita.hardmod/lib/biome_index.lua")
local biome = biome_index[DebugBiomeMapGetFilename(x, y)]
local enemy_perks = dofile_once( "mods/noita.hardmod/files/modules/enemy_perks/enemy_perks_list.lua" )
local eperk_utils = dofile_once("mods/noita.hardmod/files/modules/enemy_perks/eperk_utilities.lua")(enemy_perks) ---@type eperk_utils
local options = {
	"AREA_PROTECTOR",
	"TETHER",
}

local data = {
	x = x, y = y,
	biome = biome,
	level = 10,
	target_enemy = entity_id,
	player = EntityGetWithTag( "player_unit" )[1],
	player_poly_identity = nil,
	is_boss = true,
}
eperk_utils.give_enemy_perks( entity_id, { random_from_array( options ) }, data )