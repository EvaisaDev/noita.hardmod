local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local min_item_cost = 150
local gold_multiplier = 0.15

local eid = GetUpdatedEntityID()
local cid = GetUpdatedComponentID()
local x, y = EntityGetTransform(eid)

if not utils.GetPlayerEntity(x, y, 300) then return end

EntityRemoveComponent(eid, cid)

local cost_comp = EntityGetFirstComponentIncludingDisabled(eid, "ItemCostComponent")
if not cost_comp then return end

local gold = tonumber(StatsGetValue("gold")) or 0
local cost = math.max(min_item_cost, math.floor(gold * gold_multiplier))

ComponentSetValue2(cost_comp, "cost", cost)

local str = tostring(cost)
local strwidth = 0

for i=1,#str do
  local l = string.sub(str, i, i)
  if l ~= "1" then strwidth = strwidth + 6
  else strwidth = strwidth + 3 end
end

EntityAddComponent2(eid, "SpriteComponent", {
  _tags = "shop_cost,enabled_in_world",
  image_file = "data/fonts/font_pixel_white.xml",
  is_text_sprite = true,
  text = str,
  offset_x = strwidth * 0.5 - 1,
  offset_y = 25,
  update_transform = true,
  update_transform_rotation = false,
  z_index = -1,
})
