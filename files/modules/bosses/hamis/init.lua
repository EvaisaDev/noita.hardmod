local eid = GetUpdatedEntityID()

if GameHasFlagRun("hardmod_hamis_boss") then
	EntityAddComponent2(eid, "LuaComponent", {
		script_source_file="mods/noita.hardmod/files/modules/bosses/hamis/init.lua",
		execute_on_added = true,
		remove_after_executed = true,
	})
end
