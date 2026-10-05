perk_reworks = {
	{
		id = "REMOVE_FOG_OF_WAR",
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
	{
		id = "SHIELD",
		stackable_maximum = 3,
	},
	{
		id = "STAINLESS_ARMOUR",
		stackable_maximum = 3,
	},
	{
		id = "PROTECTION_FIRE",
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
	{
		id = "BLEED_OIL",
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
	{
		id = "PROTECTION_EXPLOSION",
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
	{
		id = "EXPLODING_CORPSES",
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
	{
		id = "PROTECTION_ELECTRICITY",
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
	{
		id = "PROTECTION_MELEE",
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
}

local function modify_perk( rework_data )
	for i = 1, #perk_list do
		local perk = perk_list[i]
		if perk.id == rework_data.id then
			for k, v in pairs( rework_data ) do
                if k ~= "id" then
                    perk[k] = v
                end
            end
            if rework_data.clear_original_game_effect then
            	perk.game_effect = nil
            end
            if rework_data.clear_original_game_effect2 then
            	perk.game_effect2 = nil
            end
        end
	end
end

if ( perk_list ~= nil ) then
	for k, v in pairs( perk_reworks ) do
		modify_perk( v )
	end
end