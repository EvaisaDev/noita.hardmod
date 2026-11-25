---@diagnostic disable: param-type-mismatch
local utils = dofile_once( "mods/noita.hardmod/lib/utilities.lua" ) ---@type utils

function death(damage_type_bit_field, message, attacker, drop_items)
    local owner = GetUpdatedEntityID()
    local ally = utils.GetInternalInt( owner, "hardmod_soul_linked_ally" ) or 0

    if ally ~= 0 and EntityGetIsAlive(ally) then
        utils.SetInternalInt( ally, "hardmod_soul_linked_ally", 0 )
        utils.EntityRemoveAllByTag( ally, "hardmod_soul_linked" )
        for _,child in ipairs(EntityGetAllChildren(ally, "hardmod_soul_linked") or {}) do
	        EntitySetComponentsWithTagEnabled(child, "hardmod_soul_link_active", false)
	    end
    end
end

function damage_received( damage, desc, entity_who_caused, is_fatal )
    local owner = GetUpdatedEntityID()
    local ally = utils.GetInternalInt( owner, "hardmod_soul_linked_ally" ) or 0
    if ally == 0 then return end
    if ( utils.GetInternalInt( owner, "hardmod_soul_linked_death" ) or 0 ) == 1 then return end -- to prevent stack overflows

	local dmg_comp_self = EntityGetFirstComponentIncludingDisabled(owner, "DamageModelComponent")
	local dmg_comp_ally = EntityGetFirstComponentIncludingDisabled(ally, "DamageModelComponent")
	if dmg_comp_self and dmg_comp_ally then
		local hp_self = ComponentGetValue2(dmg_comp_self, "hp")
		local hp_ally = ComponentGetValue2(dmg_comp_ally, "hp")
	    if damage > hp_self and EntityGetIsAlive(ally) and hp_ally >= 0.05 then
	        ComponentSetValue2(dmg_comp_self, "hp", 0.04 + damage)

	        if not utils.EntityGetChildByName(owner, "hardmod_soul_linked_protection") then
	            LoadGameEffectEntityTo(owner, "mods/noita.hardmod/files/modules/enemy_perks/entities/soul_linked_protection.xml")

	            local x, y = EntityGetTransform(ally)
	            local fow_hole = EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/entities/all_seeing_fow_hole.xml", x, y)
	            EntitySetName(fow_hole, "hardmod_soul_linked_fow_hole")
	            EntityAddChild(ally, fow_hole)
	        end
	    -- if both enemies have <1(.25) hp, they both die
	    elseif hp_self <= 0.05 and hp_ally <= 0.05 then
	    	-- remove the ally's soul linked protection entity so that they can take damage again
	    	local prot_entity = utils.EntityGetChildByName(ally, "hardmod_soul_linked_protection")
	    	if prot_entity then EntityKill(prot_entity) end
	    	-- account for off-screen shenanigans
	    	local fowh_entity = utils.EntityGetChildByName(ally, "hardmod_soul_linked_fow_hole")
	    	if fowh_entity then EntityKill(fowh_entity) end

	    	-- prevent infinite loops and the owner from immediately finding a new ally
	        utils.SetInternalInt(owner, "hardmod_soul_linked_death", 1)
	        utils.SetInternalInt(ally, "hardmod_soul_linked_death", 1)

	        -- kill the ally after a short delay (technical reasons)
	        utils.TriggerScriptDelayed(ally, "mods/noita.hardmod/files/modules/enemy_perks/scripts/soul_linked_kill_ally.lua", 5)
	    end
	end
end
