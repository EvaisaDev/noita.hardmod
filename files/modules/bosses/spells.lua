local hooks = {}---@type spell_hooks

hooks.new_spells = {
	{
		id = "HARDMOD_SUMMON_HAMIS",
		name = "$hardmod_spell_summon_hamis_name",
		description = "$hardmod_spell_summon_hamis_desc",
		sprite = "mods/noita.hardmod/files/modules/bosses/gfx/spells/summon_hamis.png",
		related_projectiles	= {"mods/noita.hardmod/files/modules/bosses/entity/projectile/summon_hamis.xml"},
		type = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level = "2,4,5",
		spawn_requires_flag = "hardmod_boss_hamis",
		spawn_probability = "0.3,0.4,0.5",
		price = 90,
		mana = 60,
		action 		= function()
			add_projectile("mods/noita.hardmod/files/modules/bosses/entity/projectile/summon_hamis.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			current_reload_time = current_reload_time + 10
		end,
	},
}

return hooks
