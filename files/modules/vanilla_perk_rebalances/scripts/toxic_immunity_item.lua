local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local toxic_materials = {
    ["radioactive_gas"] = true,
    ["radioactive_gas_static"] = true,
    ["rock_static_radioactive"] = true,
    ["ice_radioactive_static"] = true,
    ["ice_radioactive_glass"] = true,
    ["gold_radioactive"] = true,
    ["gold_static_radioactive"] = true,
}

function enabled_changed(entity_id, state)
    local root = EntityGetRootEntity(entity_id)
    if state == true then
        if root == entity_id then return end

        EntityAddComponent2(entity_id, "VariableStorageComponent", {
            name = "owner",
            value_int = root
        })
        local damage_from_material = utils.EntityGetMaterialsThatDamage(root)
        for _,md in ipairs(damage_from_material) do
            if toxic_materials[md.material] and md.damage ~= 0 then
                EntitySetDamageFromMaterial(root, md.material, 0)
                EntityAddComponent2(entity_id, "VariableStorageComponent", {
                    name = "mat_damage_tracker",
                    value_string = md.material,
                    value_float = md.damage,
                })
            end
        end
    else
        print("a")
        local last_owner = 0
        local toxic_damage_data = {}
        for _,varcomp in ipairs(EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}) do
            print(varcomp)
            local name = ComponentGetValue2(varcomp, "name")
            if name == "owner" then print("b") last_owner = ComponentGetValue2(varcomp, "value_int")
            elseif name == "mat_damage_tracker" then
                toxic_damage_data[#toxic_damage_data+1] = {
                    material = ComponentGetValue2(varcomp, "value_string"),
                    damage = ComponentGetValue2(varcomp, "value_float")
                }
            end
            EntityRemoveComponent(entity_id, varcomp)
        end
        if not EntityGetIsAlive(last_owner) then print("failed add toxic damage back to previous owner: "..last_owner) return end

        for _,ddata in ipairs(toxic_damage_data) do
            EntitySetDamageFromMaterial(last_owner, ddata.material, ddata.damage)
        end
    end
end