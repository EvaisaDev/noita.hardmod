dofile_once( "mods/noita.hardmod/lib/utilities.lua" )

local entity = GetUpdatedEntityID()
local parent = EntityGetParent( entity )

if parent ~= nil then
    local px, py = EntityGetTransform( parent )

    local parent_controls = EntityGetFirstComponent( parent, "ControlsComponent" )
    if parent_controls ~= nil then
        local mx, my = ComponentGetValue2( parent_controls, "mMousePosition" )
        EntitySetTransform( entity, mx, my )
    else
        EntitySetTransform( entity, px, py )
    end
end