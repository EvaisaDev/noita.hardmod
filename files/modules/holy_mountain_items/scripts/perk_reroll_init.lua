local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local entity_id = GetUpdatedEntityID()


local cost_comp = EntityGetFirstComponent(entity_id, "ItemCostComponent")
if not cost_comp then return end

local perk_reroll_count = tonumber(GlobalsGetValue("TEMPLE_PERK_REROLL_COUNT", "0")) or 0
local cost = math.min(utils.max_gold, 200 * 2^math.min(35, perk_reroll_count))
ComponentSetValue2(cost_comp, "cost", cost)

local spr_comp = EntityGetFirstComponent(entity_id, "SpriteComponent", "shop_cost")
if not spr_comp then return end


if cost < utils.max_gold then
    ComponentSetValue2(spr_comp, "image_file", "data/fonts/font_pixel_white.xml")
    ComponentSetValue2(spr_comp, "offset_x", utils.GetIntegerCostOffsetX(cost))
    ComponentSetValue2(spr_comp, "is_text_sprite", true)
else
    ComponentSetValue2(spr_comp, "image_file", "mods/noita.hardmod/files/modules/holy_mountain_items/gfx/infinity.png")
    ComponentSetValue2(spr_comp, "offset_x", 5)
    ComponentSetValue2(spr_comp, "is_text_sprite", false)
end



-- ComponentSetMetaCustom(ingestion_component, "ingestible_materials", values)
