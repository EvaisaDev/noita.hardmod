local utils = dofile_once( "mods/noita.hardmod/lib/utilities.lua" ) ---@type utils

local card = GetUpdatedEntityID()
local owner = EntityGetRootEntity(GetUpdatedEntityID())
if not owner then return end
local wand_entity = utils.GetHeldWand(owner)
if not wand_entity then return end

-- incur a reload manually
local acomp = EntityGetFirstComponentIncludingDisabled(wand_entity, "AbilityComponent")
if not acomp then return end
local reload_time = Random(240, 600)
local next_frame_usable = ComponentGetValue2(acomp, "mReloadNextFrameUsable")
if GameGetFrameNum() >= next_frame_usable then
	EntitySetComponentsWithTagEnabled(card, "overheated", false)
end
