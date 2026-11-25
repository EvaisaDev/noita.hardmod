local utils = dofile_once( "mods/noita.hardmod/lib/utilities.lua" ) ---@type utils
local EZWand = dofile_once("mods/noita.hardmod/lib/ezwand.lua")

local owner = GetUpdatedEntityID()
if not owner then return end
local wand_entity = utils.GetHeldWand(owner)
if not wand_entity then return end

-- incur a reload manually
local acomp = EntityGetFirstComponentIncludingDisabled(wand_entity, "AbilityComponent")
if not acomp then return end
local reload_time = Random(240, 600)
local next_frame_usable = ComponentGetValue2(acomp, "mReloadNextFrameUsable")
if GameGetFrameNum() >= next_frame_usable then
	ComponentSetValue2(acomp, "mReloadNextFrameUsable", GameGetFrameNum() + reload_time)
	ComponentSetValue2(acomp, "mReloadFramesLeft", reload_time)
	ComponentSetValue2(acomp, "reload_time_frames", reload_time)
end

local wand = EZWand(wand_entity)
if not wand then return end

local spells,always_casts = wand:GetSpells()
for _,spell in ipairs(spells) do
	if spell.action_id == "HARDMOD_OVERCLOCK" then
		EntitySetComponentsWithTagEnabled(spell.entity_id, "overheated", true)
	end
end
