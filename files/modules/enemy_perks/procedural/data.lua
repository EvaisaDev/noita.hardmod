local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local dir = utils.module_dir.."enemy_perks/"

local on_hit_callbacks = {
	{
		id = "curser",
		script_on_hit = dir.."scripts/curser_apply.lua",
		script_on_shot = function(projectile, x, y)
			local comp = EntityAddComponent2(projectile, "ParticleEmitterComponent", {
				emitted_material_name = "spark_red",
				count_min = 0,
				count_max = 2,
				x_pos_offset_min = -4,
				x_pos_offset_max = -2,
				y_pos_offset_min = -2,
				y_pos_offset_max = 4,
				x_vel_min = -10,
				x_vel_max = 10,
				y_vel_min = -10,
				y_vel_max = 10,
				lifetime_min = 1.1,
				lifetime_max = 2.8,
				create_real_particles = false,
				emit_cosmetic_particles = true,
				emission_interval_min_frames = 1,
				emission_interval_max_frames = 1,
				delay_frames = 2,
				is_emitting = true,
			})
			--We can't set these values inherently when creating a new component via lua, so set them here instead
			ComponentSetValue2(comp, "offset", -1, 0)
			ComponentSetValue2(comp, "gravity", 0, 0)
		end,
	},
	{
		id = "teleport_curser",
		script_on_hit = dir.."scripts/teleport_curser_apply.lua",
		script_on_shot = function(projectile, x, y)
			local comp = EntityAddComponent2(projectile, "SpriteParticleEmitterComponent", {
				sprite_file="data/particles/teleparticle.xml",
				lifetime=0.4,
				emission_interval_min_frames=1,
				emission_interval_max_frames=4,
				count_min=1,
				count_max=3,
			})
			--We can't set these values inherently when creating a new component via lua, so set them here instead
			print("a")
			print(table.concat({ComponentGetValue2(comp, "color_change")}, ", "))
			print(table.concat({ComponentGetValue2(comp, "randomize_position")}, ", "))
			print(table.concat({ComponentGetValue2(comp, "randomize_velocity")}, ", "))
			ComponentSetValue2(comp, "color_change", 0, 0, 0, -.2)
			ComponentSetValue2(comp, "gravity", 0, 0)
			ComponentSetValue2(comp, "scale", 1, 0.2)
			ComponentSetValue2(comp, "scale_velocity", -.2, 1)
			ComponentSetValue2(comp, "randomize_position", -5, 0, 5, 0)
			ComponentSetValue2(comp, "randomize_velocity", 0, -40, 0, 40)
			ComponentSetValue2(comp, "randomize_lifetime", -0.45, 0.2)
		end,
	}
}

local on_hit_callbacks_index = {}
for _,callback in ipairs(on_hit_callbacks) do
	on_hit_callbacks_index[callback.id] = callback
end

return {
	callbacks = on_hit_callbacks,
	callbacks_index = on_hit_callbacks_index,
}