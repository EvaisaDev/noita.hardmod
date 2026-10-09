
local entity_id = GetUpdatedEntityID()
local parent_id = EntityGetParent(entity_id)

EntityAddComponent2(
    parent_id,
    "LuaComponent",
    {
		execute_every_n_frame=-1,
		script_damage_received="data/scripts/animals/wraith_glowing_damage.lua"
    }
)
