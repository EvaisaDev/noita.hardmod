local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua")---@type utils
local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua")---@type nxml
local root = "mods/noita.hardmod/files/modules/better_anvil/"
local hooks = {}---@type hooks

local function patch_broken_wand()
	utils.modifile(
		"data/scripts/items/broken_wand_throw.lua",
		[[spell_amount = 18]], [[spell_amount = 27]]
	)

	utils.patchifile("data/scripts/items/broken_wand_spells.lua", {{
		from = [[shoot_projectile( entity_id, spell, pos_x, pos_y, vel_x, vel_y)]],
		insert_before = [[local thrown_projectile = ]],
		insert_after = [[
			EntityAddComponent2(thrown_projectile, "HomingComponent", {
				_tags = "homing_projectile",
				homing_targeting_coeff = 130.0,
				homing_velocity_multiplier = 0.86,
				detect_distance = 300,
				predefined_target = 0
			})
		]]
	}})
end

local forge_item_convert = "data/scripts/buildings/forge_item_convert.lua"
local function patch_forge_convert()
	utils.modifile(
		forge_item_convert,
		[[EntityLoad("data/entities/items/wand_level_05_better.xml", x, y - 5)]],
		[[dofile("mods/noita.hardmod/files/modules/better_anvil/forge/repaired_wand.lua")(x, y)]]
	)

	-- upgrade starter wand
	ModLuaFileAppend("data/scripts/gun/procedural/starting_wand.lua", "mods/noita.hardmod/files/modules/better_anvil/appends/starting_wand.lua")
	utils.modifile(
		forge_item_convert,
		[[for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 70, "tablet")) do]],
		[[for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 70, "hardmod_starter_wand")) do
			-- make sure item is not carried in inventory or wand
			if EntityGetRootEntity(id) == id then
				local x,y = EntityGetTransform(id)

				-- cache spells from starter wand
				local EZWand = dofile_once("mods/noita.hardmod/lib/ezwand.lua")
				local spells,always_casts = EZWand(id):GetSpells()

				-- spawn upgraded wand
				local wand_entity = EntityLoad("data/entities/items/wand_level_05_better.xml",  x, y - 12)
				local wand = EZWand(wand_entity)
				wand:RemoveSpells()
				if HasFlagPersistent("hardmod_hell_completed") then
					wand:SetSprite( "mods/noita.hardmod/files/modules/better_anvil/gfx/starter_wand_better_red.png", 10, 4, 15, 0 )
				elseif HasFlagPersistent("hardmod_game_completed") then
					wand:SetSprite( "mods/noita.hardmod/files/modules/better_anvil/gfx/starter_wand_better_gold.png", 10, 4, 15, 0 )
				else
					wand:SetSprite( "mods/noita.hardmod/files/modules/better_anvil/gfx/starter_wand_better.png", 10, 4, 15, 0 )
				end

				-- paste cached spells onto the new wand
				for _,spell_obj in ipairs(always_casts) do
					wand:AttachSpells(spell_obj.action_id)
				end
				for _,spell_obj in ipairs(spells) do
					wand:AddSpells(spell_obj.action_id)
				end

				EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)
				EntityKill(id)
				converted = true
			end
		end

		for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 70, "tablet")) do]]
	)
end

local function patch_broken_spell()
	utils.modifile(
		forge_item_convert,
		[[CreateItemActionEntity( "SUMMON_PORTAL", x, y)]],
		[[dofile("mods/noita.hardmod/files/modules/better_anvil/forge/repaired_spell.lua")(x, y)]]
	)

	ModLuaFileAppend("data/scripts/item_spawnlists.lua", root.."appends/item_spawnlists.lua")
	ModLuaFileAppend("data/scripts/buildings/statue_hand_modified.lua", root.."appends/statue_hand_modified.lua")

	for broken_spell in nxml.edit_file("data/entities/items/pickup/summon_portal_broken.xml") do
		local icomp = broken_spell:first_of("ItemComponent")
		if icomp then
			icomp:set("preferred_inventory", "FULL")
			icomp:set("play_spinning_animation", false)
		end

		local comps = { "ParticleEmitterComponent", "LightComponent", "SpriteComponent", "SpriteParticleEmitterComponent" }
		for _,name in pairs(comps) do
			for comp in broken_spell:each_of(name) do
				local tags = comp:get("_tags")
				tags = tags and tags .. "," or ""

				comp:set("_tags", tags .. "not_enabled_in_wand")
			end
		end

		broken_spell:set("tags", broken_spell:get("tags") .. ",not_enabled_in_wand")
		broken_spell:create_child("ItemActionComponent", {
			_tags = "enabled_in_world",
			action_id = "HARDMOD_BROKEN_SPELL",
		})
	end

	for file in nxml.edit_file("data/entities/buildings/statue_hand_1.xml") do
		for luacomp in file:each_of("LuaComponent") do
			if luacomp.attr.script_source_file == "data/scripts/buildings/statue_hand_state.lua" then
				file:remove_child(luacomp)
				break
			end
		end

		file:create_child("LuaComponent", {
			script_source_file = root.."scripts/statue_hand_init.lua",
			execute_on_added = true,
			remove_after_executed = true,
		})
	end
end

local function patch_random_forge_location()
	local location = dofile_once("mods/noita.hardmod/files/modules/better_anvil/forge/location.lua")

	for ps in nxml.edit_file("data/biome/_pixel_scenes.xml") do
		local scenes = ps:first_of("mBufferedPixelScenes")
		if not scenes then return end

		local orig_color_file = "data/biome_impl/snowcastle/forge_visual.png"
		for child in scenes:each_child() do
			if child:get("colors_filename") == orig_color_file then
				child:set("background_filename", root.."gfx/old_forge/background.png")
				child:set("colors_filename", root.."gfx/old_forge/visual.png")
				child:set("material_filename", root.."gfx/old_forge/material.png")
				break
			end
		end

		-- TODO: Please tell me if there's a better way to do this...
		scenes:create_child("PixelScene", {
			DEBUG_RELOAD_ME = false, clean_area_before = true,
			skip_biome_checks = true, skip_edge_textures = false,
			background_filename = root.."gfx/new_forge/background.png",
			colors_filename = root.."gfx/new_forge/visual.png",
			material_filename = root.."gfx/new_forge/material.png",
			pos_x = location.x,
			pos_y = location.y,
		})
	end
end

patch_broken_wand()
patch_forge_convert()
patch_broken_spell()

ModLuaFileAppend("data/scripts/biomes/snowcastle.lua", root.."appends/snowcastle.lua")

function hooks.magic_numbers_and_seed_initialised()
	patch_random_forge_location()
end

return hooks
