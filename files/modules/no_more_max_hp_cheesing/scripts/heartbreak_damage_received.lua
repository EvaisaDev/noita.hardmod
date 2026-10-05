function damage_received( damage, desc, entity_who_caused, is_fatal )
    local entity_id = GetUpdatedEntityID()
    local comp_id = GetUpdatedComponentID()

    -- if heartbreak is active, lose max HP equal to 50% of damage taken
    dofile_once( "mods/noita.hardmod/lib/utilities.lua" )
    local heartbreak_state = GetInternalInt( entity_id, "hardmod_heartbreak_enabled" )
    if heartbreak_state ~= nil and heartbreak_state == 1 then
        local dmg_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
        if dmg_comp ~= nil then
            local p_hp = ComponentGetValue2( dmg_comp, "hp" )
            local p_max_hp = ComponentGetValue2( dmg_comp, "max_hp" )
            
            ComponentSetValue2( dmg_comp, "max_hp", math.max( p_max_hp - ( damage * 0.5 ), 0.04 ) )
        end
    end
end