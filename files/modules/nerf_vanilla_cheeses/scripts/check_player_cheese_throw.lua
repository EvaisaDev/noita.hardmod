local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local entity_id = GetUpdatedEntityID()


function enabled_changed(_, is_enabled)
    local proj_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ProjectileComponent")
    if not proj_comp then return end

    if is_enabled and ComponentGetValue2(proj_comp, "mWhoShot") == 0 then
        EntityAddComponent2(entity_id, "LuaComponent", {
            script_source_file="mods/noita.hardmod/files/modules/nerf_vanilla_cheeses/scripts/cancel_physics_momentum.lua",
            remove_after_executed=true
        })
    end
end