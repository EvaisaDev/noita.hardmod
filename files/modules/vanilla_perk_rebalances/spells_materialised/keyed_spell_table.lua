dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
local spells = {}
---@diagnostic disable-next-line:undefined-global
for _,action in ipairs(actions) do spells[action.id] = action end
return spells