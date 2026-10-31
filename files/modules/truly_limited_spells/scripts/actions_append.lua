
local function hand_contains( hand, action_id )
	for i,card in ipairs( hand ) do
		if card.id == action_id then
			return true
		end
	end
	return false
end

local function get_actions_lua_data( action_id )
    dofile_once( "data/scripts/gun/gun_actions.lua" )
    for i,action in ipairs( actions ) do
        if action.id == action_id then
            return action
        end
    end
    return nil
end

local function find_action_entity_by_id( action_id )
	local all_cards = EntityGetWithTag( "card_action" )
	for i,card in ipairs( all_cards ) do
		if EntityGetValue( card, "ItemActionComponent", "action_id" ) == action_id then
			return card
		end
	end
	return nil
end

local function EntityIsWand( entity_id )
	local acomp = EntityGetFirstComponentIncludingDisabled( entity_id, "AbilityComponent" )
  	if not acomp then return false end
	return ComponentGetValue2( acomp, "use_gun_script" ) == true
end

local function GetHeldWand( entity_id )
	if entity_id ~= nil then
		local inv2_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "Inventory2Component" )
		local active_item = ComponentGetValue2( inv2_comp, "mActiveItem" )
		if EntityIsWand( active_item ) then
			return active_item
		end
	end
	return nil
end

local function EntityLoadAtWandTip( player_entity_id, load_this_entity )
    local wand_entity_id = GetHeldWand( player_entity_id )
    if ( not player_entity_id ) or ( not wand_entity_id ) then return end

    local ctrl_comp = EntityGetFirstComponent( player_entity_id, "ControlsComponent" )
    local hs_comp = EntityGetFirstComponentIncludingDisabled( wand_entity_id, "HotspotComponent" )
    if ctrl_comp ~= nil and hs_comp ~= nil then
        local aim_x, aim_y = ComponentGetValue2( ctrl_comp, "mAimingVectorNormalized" )
		local offset_x, offset_y = ComponentGetValue2( hs_comp, "offset" )
		local offset_mag = math.sqrt( offset_x ^ 2 + offset_y ^ 2 )

        local wx, wy = EntityGetTransform( wand_entity_id )
        local tx = wx + ( offset_mag * aim_x )
        local ty = wy + ( offset_mag * aim_y )
        return EntityLoad( load_this_entity, tx, ty )
    end
    return nil
end

local new_actions = {
    {
        id					= "HARDMOD_SPELL_INDULGENCE",
        name				= "$hardmod_spell_indulgence_name",
        description			= "$hardmod_spell_indulgence_desc",
        sprite				= "mods/noita.hardmod/files/modules/truly_limited_spells/gfx/ui_gfx/spells/indulgence.png",
        type				= ACTION_TYPE_OTHER,
        recursive 			= true,
        spawn_level			= "0",
        spawn_probability	= "0",
        spawn_requires_flag = "hardmod_cannot_spawn",
        price				= 1000,
        mana				= 20,
        action = function()
            if reflecting then return end

            local data = {}
            if ( #deck > 0 ) then
                data = deck[1]
            elseif ( #hand > 0 ) then
                data = hand[1]
            else
                data = nil
            end

            local rec = check_recursion( data, recursion_level )
            
            if ( data ~= nil ) and ( rec > -1 ) and ( data.uses_remaining == 0 ) then

                -- determine the spell's max uses
                local max_uses = -1
                local lua_data = get_actions_lua_data( data.id )
                if lua_data.max_uses then
                    max_uses = lua_data.max_uses
                end

                -- how much money does the player have?
                local player = GetUpdatedEntityID()
                local wcomp = EntityGetFirstComponent( player, "WalletComponent" )
                if wcomp == nil then return end
                local money = ComponentGetValue2( wcomp, "money" )

                -- determine the cost for this spell
                local cast_price
                if data.id == "DIVIDE_10" then
                    cast_price = 500
                elseif max_uses <= 2 or data.recursive then -- i.e. Circle of Vigour, Greek letters
                    cast_price = 250
                elseif max_uses <= 5 then -- i.e. Black Hole
                    cast_price = 125
                elseif max_uses <= 10 then
                    cast_price = 50
                elseif max_uses <= 20 then
                    cast_price = 25
                else
                    cast_price = 10
                end
                if lua_data.never_unlimited then
                    cast_price = cast_price * 2
                end

                local x, y = EntityGetTransform( GetUpdatedEntityID() )
                if money >= cast_price then
                    ComponentSetValue2( wcomp, "money", money - cast_price )

                    data.action( rec )
                    mana = mana - data.mana

                    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/goldnugget/create", x, y )
                    if ModSettingGet( "noita.hardmod.print_indulgence_cost" ) == true then
                        local cost_label = EntityLoadAtWandTip( GetUpdatedEntityID(), "mods/noita.hardmod/files/modules/truly_limited_spells/entities/misc/indulgence_cost_label.xml" )
                        EntityAddComponent2( cost_label, "VariableStorageComponent", {
                            name = "hardmod_indulgence_cast_price",
                            value_int = cast_price,
                        })
                    end
                else
                    GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y )
                    if ModSettingGet( "noita.hardmod.print_indulgence_cost" ) == true then
                        GamePrint( "You don't have enough gold to force-cast " .. GameTextGetTranslatedOrNot( data.name ) )
                    end
                end
            else
                mana = mana + 40
                draw_actions( 1, true )
            end
        end,
    },
    {
        id					= "HARDMOD_SPELL_INFINITY",
        name				= "$hardmod_spell_infinity_name",
        description			= "$hardmod_spell_infinity_desc",
        sprite				= "mods/noita.hardmod/files/modules/truly_limited_spells/gfx/ui_gfx/spells/infinity.png",
        type				= ACTION_TYPE_OTHER,
        recursive 			= true,
        spawn_level			= "0",
        spawn_probability	= "0",
        spawn_requires_flag = "hardmod_cannot_spawn",
        price				= 800,
        mana				= 80,
        action = function()
            if reflecting then return end

            local data = {}
            if ( #deck > 0 ) then
                data = deck[1]
            elseif ( #hand > 0 ) then
                data = hand[1]
            else
                data = nil
            end

            local rec = check_recursion( data, recursion_level )
            
            if ( data ~= nil ) and ( rec > -1 ) and ( data.uses_remaining == 0 ) then
                data.action( rec )
                mana = mana - data.mana
            else
                mana = mana + 100
                draw_actions( 1, true )
            end
        end,
    },
    -- following spells are defined here since they are too powerful to be used without this module's nerfs
    {
        id                  = "HARDMOD_SPELL_DAMAGE_DOUBLE",
        name                = "$hardmod_spell_damage_double_name",
        description         = "$hardmod_spell_damage_double_desc",
        sprite              = "mods/noita.hardmod/files/modules/truly_limited_spells/gfx/ui_gfx/spells/damage_double.png",
        type                = ACTION_TYPE_MODIFIER,
        spawn_level         = "1,2,3,4,5,6,10", -- 2/3 of DAMAGE
        spawn_probability   = "0.4,0.4,0.6,0.4,0.4,0.6,0.6", -- 2/3 of DAMAGE
        price               = 160,
        mana                = 20,
        max_uses            = 10,
        custom_xml_file     = "mods/noita.hardmod/files/modules/truly_limited_spells/entities/custom_cards/card_damage_double.xml",
        action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 10
                                shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0

                                c.extra_entities = c.extra_entities .. "mods/noita.hardmod/files/modules/truly_limited_spells/entities/spells/damage_double.xml,"
                                c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
                                draw_actions( 1, true )

                                if reflecting then return end
                                local x, y = EntityGetTransform( GetUpdatedEntityID() )
                                GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/black_hole/create", x, y )
                            end,
    },
    {
        id                  = "HARDMOD_SPELL_OVERKILL",
        name                = "$hardmod_spell_overkill_name",
        description         = "$hardmod_spell_overkill_desc",
        sprite              = "mods/noita.hardmod/files/modules/truly_limited_spells/gfx/ui_gfx/spells/overkill.png",
        type                = ACTION_TYPE_MODIFIER,
        spawn_level         = "5,6,10",
        spawn_probability   = "0.1,0.2,0.5",
        price               = 320,
        mana                = 50,
        max_uses            = 10,
        custom_xml_file     = "mods/noita.hardmod/files/modules/truly_limited_spells/entities/custom_cards/card_damage_double.xml",
        action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 25
                                shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0

                                c.extra_entities = c.extra_entities .. "mods/noita.hardmod/files/modules/truly_limited_spells/entities/spells/overkill.xml,"
                                c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,"
                                draw_actions( 1, true )

                                if reflecting then return end
                                local x, y = EntityGetTransform( GetUpdatedEntityID() )
                                GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/black_hole_big/create", x, y )
                            end,
    },
}

local reworked_actions = {
    ["ALPHA"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["GAMMA"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["TAU"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["OMEGA"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["MU"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["PHI"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["SIGMA"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["APOTHEOSIS_CHI"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["APOTHEOSIS_KAPPA"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["ZETA"] = {
        max_uses = 30,
        never_unlimited = true,
    },

    ["RESET"] = {
        action = function()
            current_reload_time = current_reload_time - 25
            
            move_hand_to_discarded()
            
            for i,v in ipairs( deck ) do
                table.insert( discarded, v )
            end
            
            hand = {}
            deck = {}
            
            if ( force_stop_draws == false ) then
                force_stop_draws = true
                move_discarded_to_deck()
                order_deck()
            end
        end,
    },
}

for _,action in pairs(actions) do
    if reworked_actions[action.id] then
        for k,v in pairs(reworked_actions[action.id]) do
            action[k] = v
        end

        action["hardmod_reworked"] = true
    end
end

for _,action in pairs(new_actions) do
    table.insert(actions, action)
end
