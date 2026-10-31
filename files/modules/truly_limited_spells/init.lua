local hooks = {}
local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml

ModMaterialsFileAdd( "mods/noita.hardmod/files/modules/truly_limited_spells/materials.xml")

for file in nxml.edit_file("data/entities/items/pickup/spell_refresh.xml") do
	local item = file:first_of("ItemComponent")
	if item then
		item:set("auto_pickup", false)
	end
end

hooks.mod_post_init = function()
	ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/noita.hardmod/files/modules/truly_limited_spells/scripts/perks_append.lua" )
	ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/noita.hardmod/files/modules/truly_limited_spells/scripts/actions_append.lua" )
	ModLuaFileAppend( "data/entities/animals/boss_wizard/death.lua", "mods/noita.hardmod/files/modules/truly_limited_spells/scripts/animals/boss_wizard_death_append.lua" )
	ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua", "mods/noita.hardmod/files/modules/truly_limited_spells/scripts/biomes/temple_altar_append.lua" )
end

hooks.player_spawned = function( player, is_run_start )
	if is_run_start then
		if ModSettingGet( "noita.hardmod.spawn_truly_unlimited_spells_test_package" ) then
			EntitySetTransform( player, -672, 1415 )
			local px, py = EntityGetTransform( player )
			CreateItemActionEntity( "HARDMOD_SPELL_INDULGENCE", px, py )
			CreateItemActionEntity( "HARDMOD_SPELL_INFINITY", px, py )
			CreateItemActionEntity( "BLACK_HOLE", px, py )
			CreateItemActionEntity( "BOMB", px, py )
			CreateItemActionEntity( "FLAMETHROWER", px, py )
			CreateItemActionEntity( "MATTER_EATER", px, py )
			CreateItemActionEntity( "ALPHA", px, py )
			CreateItemActionEntity( "GAMMA", px, py )
			CreateItemActionEntity( "OMEGA", px, py )
			CreateItemActionEntity( "MU", px, py )
			CreateItemActionEntity( "RECHARGE", px, py )
			CreateItemActionEntity( "RECHARGE", px, py )
			EntityLoad( "data/entities/items/pickup/goldnugget_10000.xml", px, py )

		    dofile_once( "data/scripts/perks/perk.lua" )
		    perk_spawn( px, py - 20, "HARDMOD_PERK_SPELL_GEMS", true )
		    perk_spawn( px, py - 20, "EDIT_WANDS_EVERYWHERE", true )

		    if ModIsEnabled( "spell_lab_shugged" ) then
				WANDS = dofile_once( "mods/spell_lab_shugged/files/lib/wands.lua")

				local wand = EntityLoad( "data/entities/items/wand_level_01.xml", px, py - 40 )
				local wand_data = {
					stats = {
						shuffle_deck_when_empty = false,
						actions_per_round = 1,
						fire_rate_wait = 10,
						reload_time = 20,
						mana_max = 100000,
						mana_charge_speed = 100000,
						capacity = 26,
						spread_degrees = 0,
						speed_multiplier = 1,
					},
					sprite = {
						file = "data/items_gfx/wands/wand_0821.png",
						hotspot = {
							x = 18.0,
							y = 0.0,
						},
						x = 4,
						y = 3,
					},
				}

				WANDS.initialize_wand( wand, wand_data )
			end
		end
	end
end

return hooks --Don't forget to do this if you want your changes to apply!!!!
