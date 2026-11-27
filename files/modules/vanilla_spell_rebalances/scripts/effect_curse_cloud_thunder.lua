dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

SetRandomSeed(GameGetFrameNum(), pos_x + pos_y + entity_id)

local offset_x = Random(-16, 16)

shoot_projectile(
	entity_id, "mods/noita.hardmod/files/modules/vanilla_spell_rebalances/entities/curse_cloud_thunder.xml",
	pos_x + offset_x, pos_y - 16, 0, 4000
)
