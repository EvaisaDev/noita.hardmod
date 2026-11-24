function enabled_changed(e, state)
	if state then
		if EntityGetFirstComponent(e, "UIIconComponent", "effect_no_heal_in_meat_biome") then return end

		EntityAddComponent2(e, "UIIconComponent", {
			_tags = "effect_no_heal_in_meat_biome",
			name = "$hardmod_statusname_meat_curse",
			description = "$hardmod_statusdesc_meat_curse",
			icon_sprite_file = "mods/noita.hardmod/files/modules/qol/status_icons/antiheal.png",
			is_perk = true
		})
	else
		for _,ui_icon_comp in ipairs(EntityGetComponent(e, "UIIconComponent", "effect_no_heal_in_meat_biome") or {}) do
			EntityRemoveComponent(e, ui_icon_comp)
		end
	end
end