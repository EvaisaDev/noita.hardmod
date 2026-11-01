---@diagnostic disable: undefined-global

local hooks = {}

hooks.new_spells = {
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
}

hooks.spell_patches = {
	["X_RAY"] = {
		spawn_level       = "0,1,2,3,4,5,6",
		spawn_probability = "0.4,0.6,0.7,0.8,1,0.8,0.7",
		max_uses          = 5,
		never_unlimited   = true,
	},
}

return hooks