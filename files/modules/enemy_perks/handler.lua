local max_icons_displayed = 4
local y_offset_amount = 14
local icon_buffer = 10

local half_icon_buffer = icon_buffer*.5


local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)

function init(eid)
	local self = GetUpdatedComponentID()
	ComponentSetValue2(self, "mNextExecutionTime", GameGetFrameNum() + 1)

	for _,luacomp in ipairs(EntityGetComponent(root, "LuaComponent") or {}) do
		if ComponentGetValue2(luacomp, "script_death") == "mods/noita.hardmod/files/modules/enemy_perks/perk_holder_died.lua" then return end
	end
	EntityAddComponent2(root, "LuaComponent", {
		script_death = "mods/noita.hardmod/files/modules/enemy_perks/perk_holder_died.lua"
	})
end

if entity_id == root then return end

local enemy_perks_indexed = dofile_once("mods/noita.hardmod/files/modules/enemy_perks/enemy_perks_index.lua")

local enemy_perk_data
for _,varcomp in ipairs(EntityGetComponent(entity_id, "VariableStorageComponent") or {}) do
	if ComponentGetValue2(varcomp, "name") == "enemy_perk_data" then enemy_perk_data = varcomp break end
end

-- [[
local function update_icons()
	local offset_y = 0
	for _,hitbox in ipairs(EntityGetComponent(root, "HitboxComponent") or {}) do
		offset_y = math.max(offset_y, -ComponentGetValue2(hitbox, "aabb_min_y"))
	end
	offset_y = offset_y + y_offset_amount

	for _,spr_comp in ipairs(EntityGetComponent(entity_id, "SpriteComponent") or {}) do
		EntityRemoveComponent(entity_id, spr_comp)
	end

	local enemy_perks = {}
	for perk_id in ComponentGetValue2(enemy_perk_data, "value_string"):gmatch("([^,]+)") do
		enemy_perks[#enemy_perks+1] = enemy_perks_indexed[perk_id]
	end

	table.sort(enemy_perks, function(a, b)
		return a.priority > b.priority
	end)

	local num_icons = math.min(#enemy_perks, max_icons_displayed)
	for i=1,num_icons do
		local sprite = (i == max_icons_displayed and #enemy_perks > max_icons_displayed) and "mods/noita.hardmod/files/modules/enemy_perks/perk_icons/expand.png" or enemy_perks[i].icon
		EntityAddComponent2(entity_id, "SpriteComponent", {
			offset_x = -((i-1)*icon_buffer-num_icons*half_icon_buffer),
			offset_y = offset_y,
			image_file = sprite,
		})
	end
end--]]

update_icons()