---@diagnostic disable: undefined-global

local new_perks = {
  {
	id = "HARDMOD_TINKER_AT_PEDESTALS",
	ui_name = "$hardmod_perk_tinker_at_pedestals_name",
	ui_description = "$hardmod_perk_tinker_at_pedestals_desc",
	ui_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/tinker_at_pedestals_016.png",
	perk_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/tinker_at_pedestals.png",
	stackable = STACKABLE_NO,
	one_off_effect = false,
	usable_by_enemies = false,
	func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
	  if pickup_count > 1 then return end
	  EntityAddChild(entity_who_picked, EntityLoad("mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/effect_tinker_at_pedestals.xml"))
	end
	},
	{
		id = "HARDMOD_ITEM_IMMUNITIES",
		ui_name = "$hardmod_perk_item_immunities_name",
		ui_description = "$hardmod_perk_item_immunities_desc",
		ui_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/item_immunities_016.png",
		perk_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/item_immunities.png",
		stackable = false,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function(perk, player, name, count)
	  if count > 1 then return end
			EntityAddChild(player, EntityLoad("mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/effect_item_immunities.xml"))
		end
	},
	{ --Nabbed from Apotheosis
		id = "HARDMOD_OVERSIZED_SHIELD",
		id_append = "SHIELD",
		ui_name = "$hardmod_perk_oversized_shield_name",
		ui_description = "$hardmod_perk_oversized_shield_desc",
		ui_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/shield_oversized_016.png",
		perk_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/shield_oversized.png",
		stackable = STACKABLE_YES,
		stackable_how_often_reappears = 10,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/perks/shield_oversized.xml", x, y )

			if ModIsEnabled("quant.ew") then
				GlobalsSetValue("PERK_SHIELD_OVERSIZED_COUNT", tostring(pickup_count-1))
			end
			local shield_num = tonumber( GlobalsGetValue( "PERK_SHIELD_OVERSIZED_COUNT", "0" ) )
			local shield_radius = 75 + shield_num * 3.0
			local charge_speed = math.max( 0.01 - shield_num * 0.05, 0.02 )
			shield_num = shield_num + 1
			GlobalsSetValue( "PERK_SHIELD_OVERSIZED_COUNT", tostring( shield_num ) )

			local comps = EntityGetComponent( child_id, "EnergyShieldComponent" )
			if( comps ~= nil ) then
				for i,comp in ipairs( comps ) do
					ComponentSetValue2( comp, "radius", shield_radius )
					ComponentSetValue2( comp, "recharge_speed", charge_speed )
				end
			end

			comps = EntityGetComponent( child_id, "ParticleEmitterComponent" )
			if( comps ~= nil ) then
				for i,comp in ipairs( comps ) do
					local minradius,maxradius = ComponentGetValue2( comp, "area_circle_radius" )

					if ( minradius ~= nil ) and ( maxradius ~= nil ) then
						if ( minradius == 0 ) then
							ComponentSetValue2( comp, "area_circle_radius", 0, shield_radius )
						elseif ( minradius == 10 ) then
							ComponentSetValue2( comp, "area_circle_radius", shield_radius, shield_radius )
						end
					end
				end
			end

			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/shield_oversized.xml", x, y )
			local comps = EntityGetComponent( child_id, "EnergyShieldComponent" )
			if( comps ~= nil ) then
				for i,comp in ipairs( comps ) do
					ComponentSetValue2( comp, "radius", 64 )
					ComponentSetValue2( comp, "recharge_speed", 0.02 )
				end
			end

			comps = EntityGetComponent( child_id, "ParticleEmitterComponent" )
			if( comps ~= nil ) then
				for i,comp in ipairs( comps ) do
					local minradius,maxradius = ComponentGetValue2( comp, "area_circle_radius" )

					if ( minradius ~= nil ) and ( maxradius ~= nil ) then
						if ( minradius == 0 ) then
							ComponentSetValue2( comp, "area_circle_radius", 0, 64 )
						elseif ( minradius == 10 ) then
							ComponentSetValue2( comp, "area_circle_radius", 64, 64 )
						end
					end
				end
			end

			EntityAddChild( entity_who_picked, child_id )
		end,
		_remove = function( entity_who_picked )
			local shield_num = tonumber( GlobalsGetValue( "PERK_SHIELD_OVERSIZED_COUNT", "0" ) ) - 1
			GlobalsSetValue( "PERK_SHIELD_OVERSIZED_COUNT", tostring( shield_num ) )

			local children = EntityGetAllChildren(entity_who_picked) or {}
			local largest_radius = 0
			local largest_shield = 0
			for k=1,#children do
				if EntityGetName(children[k]) == "hardmod_oversized_shield" then
					local r = ComponentGetValue2(EntityGetFirstComponentIncludingDisabled(children[k],"EnergyShieldComponent"),"radius")
					if r > 0 then
						largest_radius = r
						largest_shield = children[k]
					end
				end
			end
			if largest_shield > 0 then EntityKill(largest_shield) end
		end,
		func_remove = function( entity_who_picked )
			local shield_num = 0
			GlobalsSetValue( "PERK_SHIELD_OVERSIZED_COUNT", tostring( shield_num ) )
	end,
	}
}

local perk_reworks = {
	["REMOVE_FOG_OF_WAR"] = {
		ui_name = "$hardmod_perk_all_seeing_eye_name",
		ui_description = "$hardmod_perk_all_seeing_eye_desc",
		ui_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/all_seeing_eye_016.png",
		perk_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/all_seeing_eye.png",
		clear_original_game_effect = true,
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddChild( entity_who_picked, EntityLoad( "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/perks/all_seeing_eye.xml" ) )
		end,
		func_remove = function( entity_who_picked )
			local perk_entity = EntityGetAllChildren( entity_who_picked, "hardmod_all_seeing_eye_entity" )[1]
			if perk_entity ~= nil then
				EntityKill( perk_entity )
			end
		end,
	},
	["SHIELD"] = { stackable_maximum = 3 },
	["STAINLESS_ARMOUR"] = { stackable_maximum = 3 },
	["PROTECTION_FIRE"] = {
		ui_name = "$hardmod_perk_protection_fire_name",
		ui_description = "$hardmod_perk_protection_fire_desc",
		ui_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/protection_fire_016.png",
		perk_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/protection_fire.png",
		clear_original_game_effect = true,
		stackable = STACKABLE_YES,
		stackable_maximum = 3,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "fire" )
				local current_ignite_prob = ComponentGetValue2( dmg_comp, "fire_probability_of_ignition" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "fire", current_mtp * 0.5 )
				ComponentSetValue2( dmg_comp, "fire_probability_of_ignition", current_ignite_prob * 0.5 )
			end
		end,
		func_remove = function( entity_who_picked )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "fire" )
				local current_ignite_prob = ComponentGetValue2( dmg_comp, "fire_probability_of_ignition" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "fire", current_mtp * 2 )
				ComponentSetValue2( dmg_comp, "fire_probability_of_ignition", current_ignite_prob * 2 )
			end
		end,
	},
	["BLEED_OIL"] = {
		ui_description = "$hardmod_perk_bleed_oil_desc",
		clear_original_game_effect = true,
		remove_other_perks = nil,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "fire" )
				local current_ignite_prob = ComponentGetValue2( dmg_comp, "fire_probability_of_ignition" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "fire", current_mtp * 0.5 )
				ComponentSetValue2( dmg_comp, "fire_probability_of_ignition", current_ignite_prob * 0.5 )

				ComponentSetValue2( dmg_comp, "blood_material", "oil" )
				ComponentSetValue2( dmg_comp, "blood_spray_material", "oil" )
				ComponentSetValue2( dmg_comp, "blood_multiplier", 3.0 )
				ComponentSetValue2( dmg_comp, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_oil_$[1-3].xml" )
				ComponentSetValue2( dmg_comp, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_oil_$[1-3].xml" )
			end
		end,
		func_remove = function( entity_who_picked )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "fire" )
				local current_ignite_prob = ComponentGetValue2( dmg_comp, "fire_probability_of_ignition" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "fire", current_mtp * 2 )
				ComponentSetValue2( dmg_comp, "fire_probability_of_ignition", current_ignite_prob * 2 )

				ComponentSetValue2( dmg_comp, "blood_material", "blood" )
				ComponentSetValue2( dmg_comp, "blood_spray_material", "blood" )
				ComponentSetValue2( dmg_comp, "blood_multiplier", 1.0 )
				ComponentSetValue2( dmg_comp, "blood_sprite_directional", "" )
				ComponentSetValue2( dmg_comp, "blood_sprite_large", "" )
			end
		end,
	},
	["PROTECTION_EXPLOSION"] = {
		ui_name = "$hardmod_perk_protection_explosion_name",
		ui_description = "$hardmod_perk_protection_explosion_desc",
		ui_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/protection_explosion_016.png",
		perk_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/protection_explosion.png",
		clear_original_game_effect = true,
		stackable = STACKABLE_YES,
		stackable_maximum = 3,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "explosion" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "explosion", current_mtp * 0.5 )
			end
		end,
		func_remove = function( entity_who_picked )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "explosion" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "explosion", current_mtp * 2 )
			end
		end,
	},
	["EXPLODING_CORPSES"] = {
		ui_description = "$hardmod_perk_exploding_corpses_desc",
		clear_original_game_effect2 = true,
		remove_other_perks = nil,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "explosion" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "explosion", current_mtp * 0.5 )
			end
		end,
		func_remove = function( entity_who_picked )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "explosion" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "explosion", current_mtp * 2 )
			end
		end,
	},
	["PROTECTION_ELECTRICITY"] = {
		ui_name = "$hardmod_perk_protection_electricity_name",
		ui_description = "$hardmod_perk_protection_electricity_desc",
		ui_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/protection_electricity_016.png",
		perk_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/protection_electricity.png",
		clear_original_game_effect = true,
		stackable = STACKABLE_YES,
		stackable_maximum = 3,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "electricity" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "electricity", current_mtp * 0.5 )
			end
		end,
		func_remove = function( entity_who_picked )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "electricity" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "electricity", current_mtp * 2 )
			end
		end,
	},
	["PROTECTION_MELEE"] = {
		ui_name = "$hardmod_perk_protection_melee_name",
		ui_description = "$hardmod_perk_protection_melee_desc",
		ui_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/protection_melee_016.png",
		perk_icon = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/perks/protection_melee.png",
		clear_original_game_effect = true,
		stackable = STACKABLE_YES,
		stackable_maximum = 3,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "melee" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "melee", current_mtp * 0.5 )
			end
		end,
		func_remove = function( entity_who_picked )
			local dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local current_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "melee" )
				ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "melee", current_mtp * 2 )
			end
		end,
	},
	["EDIT_WANDS_EVERYWHERE"] = { not_in_default_perk_pool = true },
	["NO_WAND_EDITING"] = { not_in_default_perk_pool = true },
	["EXTRA_MONEY"] = { not_in_default_perk_pool = true },
	["PROJECTILE_REPULSION"] = { not_in_default_perk_pool = true },
}

if perk_list ~= nil then
	for _,perk in pairs(perk_list) do
		if perk_reworks[perk.id] then
			for k,v in pairs(perk_reworks[perk.id]) do
				perk[k] = v
			end
		end
	end

	for _,perk in pairs(new_perks) do
		table.insert(perk_list, perk)
	end
end
