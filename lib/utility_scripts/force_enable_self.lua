function enabled_changed(eid, state)
    print("updated: "..tostring(state))
    if state then return end
    local entity_id = GetUpdatedEntityID()
    local self = GetUpdatedComponentID()
    for _,component in ipairs(EntityGetAllComponents(entity_id)) do
        if component ~= self then EntitySetComponentIsEnabled(entity_id, component, true) end
    end
    EntityRemoveComponent(entity_id, self)
end