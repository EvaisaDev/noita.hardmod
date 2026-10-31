local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
EntityAddComponent2(root, "LuaComponent", {
	script_source_file = "mods/noita.hardmod/files/modules/enemy_perks/scripts/curser_projectile_explode.lua",
	execute_every_n_frame = -1,
	execute_on_removed = true,
})

EntityRemoveComponent(entity_id, GetUpdatedComponentID())