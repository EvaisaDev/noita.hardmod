local entity_id = GetUpdatedEntityID()

for _,varcomp in ipairs(EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}) do
    if ComponentGetValue2(varcomp, "name") == "owner" then
        ComponentSetValue2(varcomp, "value_int", EntityGetRootEntity(entity_id))
        return
    end
end