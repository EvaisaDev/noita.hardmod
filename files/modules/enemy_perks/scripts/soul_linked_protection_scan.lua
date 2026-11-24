local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local prot_entity = GetUpdatedEntityID()
local owner = EntityGetRootEntity(prot_entity)

-- if the ally is no longer alive, delete the owner's protection
local ally = utils.GetInternalInt(owner, "hardmod_soul_linked_ally") or 0
if ally == 0 or not EntityGetIsAlive(ally) then
	utils.SetInternalInt(owner, "hardmod_soul_linked_ally", 0)
    utils.EntityRemoveAllByTag(owner, "hardmod_soul_linked")
	EntityKill(prot_entity)
end
