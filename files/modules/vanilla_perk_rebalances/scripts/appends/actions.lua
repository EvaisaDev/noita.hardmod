local new_actions = {
    {
        id                = "HARDMOD_PINPOINTER",
        name              = "$hardmod_spell_pinpointer_name",
        description       = "$hardmod_spell_pinpointer_desc",
        sprite            = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/ui_gfx/spells/pinpointer.png",
        type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4,5,6", -- SPREAD_REDUCE
		spawn_probability = "0.8,0.8,0.8,0.8,0.7,0.6", -- SPREAD_REDUCE
        custom_xml_file   = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/custom_cards/card_pinpointer.xml",
        price             = 100,
        mana              = 2,
        action = function()
        	c.spread_degrees = c.spread_degrees - 12
        	draw_actions( 1, true )
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
