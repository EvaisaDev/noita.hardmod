local item_effects = dofile_once("mods/noita.hardmod/files/modules/vanilla_perk_rebalances/scripts/perks/item_effects_data.lua")

local entity = GetUpdatedEntityID()
local player = EntityGetRootEntity(entity)

local inventory
for _,child in pairs(EntityGetAllChildren(player) or {}) do
	if EntityGetName(child) == "inventory_quick" then
		inventory = child
		break
	end
end
if not inventory then return end

local inventory_component = EntityGetFirstComponentIncludingDisabled(player, "Inventory2Component")
if not inventory_component then return end


local state = true
local active_item = ComponentGetValue2(inventory_component, "mActualActiveItem")

local weakening = EntityGetAllChildren(player, "spirit_weaken_effect") or {}
if #weakening > 0 then state = false end

for _,item in pairs(EntityGetAllChildren(inventory) or {}) do
	local func = item_effects[EntityGetFilename(item)]
	if func and item ~= active_item then
		func(item, state)
	end
end