
function shot(entity_id)
	EntityAddComponent2(entity_id, "LuaComponent", {
		script_source_file = "mods/noita.hardmod/files/modules/enemy_perks/scripts/dark_flames.lua",
		execute_every_n_frame = 1,
	})
end
