---@diagnostic disable: undefined-global

local new_actions = {
    {
        id                = "HARDMOD_PINPOINTER",
        name              = "$hardmod_spell_pinpointer_name",
        description       = "$hardmod_spell_pinpointer_desc",
        sprite            = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/spells/pinpointer.png",
        type              = ACTION_TYPE_PASSIVE,
		spawn_level       = "1,2,3,4,5,6", -- SPREAD_REDUCE
		spawn_probability = "0.8,0.8,0.8,0.8,0.7,0.6", -- SPREAD_REDUCE
        custom_xml_file   = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/custom_cards/card_pinpointer.xml",
        price             = 100,
        mana              = 2,
        action = function()
        	draw_actions(1, true)
        end,
    },
    {
	    id                  = "HARDMOD_UPGRADE_CAPACITY",
	    name 		        = "$hardmod_spell_upgrade_capacity_name",
	    description         = "$hardmod_spell_upgrade_capacity_desc",
	    sprite 		        = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/spells/upgrade_capacity.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "hardmod_impossible_spawn",
		custom_xml_file 	= "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/custom_cards/card_upgrade_capacity.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },
    {
	    id                  = "HARDMOD_UPGRADE_FIRE_RATE",
	    name 		        = "$hardmod_spell_upgrade_fire_rate_name",
	    description         = "$hardmod_spell_upgrade_fire_rate_desc",
	    sprite 		        = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/spells/upgrade_fire_rate.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "hardmod_impossible_spawn",
		custom_xml_file 	= "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/custom_cards/card_upgrade_fire_rate.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },
    {
	    id                  = "HARDMOD_UPGRADE_MAX_MANA",
	    name 		        = "$hardmod_spell_upgrade_max_mana_name",
	    description         = "$hardmod_spell_upgrade_max_mana_desc",
	    sprite 		        = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/spells/upgrade_max_mana.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "hardmod_impossible_spawn",
		custom_xml_file 	= "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/custom_cards/card_upgrade_max_mana.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },
    {
	    id                  = "HARDMOD_UPGRADE_MANA_CHARGE_SPEED",
	    name 		        = "$hardmod_spell_upgrade_mana_charge_speed_name",
	    description         = "$hardmod_spell_upgrade_mana_charge_speed_desc",
	    sprite 		        = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/spells/upgrade_mana_charge_speed.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "hardmod_impossible_spawn",
		custom_xml_file 	= "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/custom_cards/card_upgrade_mana_charge_speed.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },
    {
	    id                  = "HARDMOD_UPGRADE_REMOVE_ALWAYS_CAST",
	    name 		        = "$hardmod_spell_upgrade_remove_always_cast_name",
	    description         = "$hardmod_spell_upgrade_remove_always_cast_desc",
	    sprite 		        = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/spells/upgrade_remove_always_cast.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "hardmod_impossible_spawn",
		custom_xml_file 	= "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/custom_cards/card_upgrade_remove_always_cast.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },
}

local reworked_actions = {
	["X_RAY"] = {
		spawn_level       = "0,1,2,3,4,5,6",
		spawn_probability = "0.4,0.6,0.7,0.8,1,0.8,0.7",
		max_uses          = 5,
		never_unlimited   = true,
	},
}

for _,action in pairs(new_actions) do
    table.insert(actions, action)
end

for _,action in pairs(actions) do
	if reworked_actions[action.id] then
		for k,v in pairs(reworked_actions[action.id]) do
			action[k] = v
		end

		action["hardmod_reworked"] = true
	end
end
