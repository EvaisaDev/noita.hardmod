for _,varcomp in ipairs(EntityGetComponentIncludingDisabled(GetUpdatedEntityID(), "VariableStorageComponent") or {}) do
    if ComponentGetValue2(varcomp, "name") == "ghost_id" then
        local eid = ComponentGetValue2(varcomp, "value_int")
        if EntityGetName(eid) == "$animal_ghost" then EntityKill(eid) end
    end
end