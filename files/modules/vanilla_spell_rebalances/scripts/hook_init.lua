local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua")---@type utils

local eid = GetUpdatedEntityID()
local projcomp = EntityGetFirstComponentIncludingDisabled(eid, "ProjectileComponent")
if not projcomp then EntityKill(eid) return end

local shooter = ComponentGetValue2(projcomp, "mEntityThatShot")
if not shooter or shooter == 0 then
	shooter = ComponentGetValue2(projcomp, "mWhoShot")
end

utils.SetInternalInt(eid, "target_eid", shooter)

EntityAddComponent2(eid, "LuaComponent", {
	script_source_file = "mods/noita.hardmod/files/modules/vanilla_spell_rebalances/scripts/hook_move.lua",
	execute_every_n_frame = 1,
})
