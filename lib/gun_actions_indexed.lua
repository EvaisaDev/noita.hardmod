dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
local indexed_gun_actions = {}
---@diagnostic disable-next-line:undefined-global
for _, action in ipairs(actions or {}) do
    indexed_gun_actions[action.id or "NULL"] = action
end

return indexed_gun_actions