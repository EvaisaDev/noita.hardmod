---@class module_list
local modules = {
	-- List of all module IDs to load, in order
	list = {
		"test_module_dont_run",
		"example",
		"nerfed_combat_healing",
		"enemy_perks",
		"trappier_traps",
		"cheeseless_triggers",
		"logo_splash",
		"starter_wands",
		"unshuffle",
		"limited_spells",
		"vanilla_perk_rebalances",
		"vanilla_spell_rebalances",
		"spells_reweighted",
		"vanilla_quests",
		"vanilla_bosses",
		"less_explosive",
		"holy_mountain_rework",
		"holy_mountain_items",
		"no_more_max_hp_cheesing",
		"phantom_nemesis",
		"alt_fire_anything",
		"ending",
		"credits",
		"nerf_vanilla_cheeses",
		"chest_tweaks",
		"better_anvil",
		"rapidfire_nerfs",
		"trial_perks",
		"biome_map",
		"biome_modifiers",
		"stronger_enemies",
		"potions",
		"alternate_biomes",
		"polymorph_gui",
		"worse_digging",
		"vanilla_bugfixes",
		"spell_variety",
		"wand_variety",
		"for_the_worthy",
		-- "no_more_instant_recharge", -- needs to be fixed
		"snail",
		"greed_curse_rework",
	},
	-- `true` to force enable, `false` to force disable
	forced_enable_state = {
		test_module_dont_run = false,
		example = false,
		credits = true,
	},
	-- Having any of these modules disabled will not give the win cosmetic
	integral_modules = {
		-- 100% needed
		"enemy_perks",
		"limited_spells",
		"holy_mountain_rework",
		"vanilla_quests",
		"vanilla_bosses",
		"vanilla_perk_rebalances",
		"vanilla_spell_rebalances",
		"spells_reweighted",
		"phantom_nemesis",
		"rapidfire_nerfs",
		"stronger_enemies",
		"ending",
		"biome_map",

		-- cheeses or other stuff, not fully sure
		"no_more_max_hp_cheesing",
		"nerf_vanilla_cheeses",
		"nerfed_combat_healing",
		"cheeseless_triggers",
		"biome_modifiers",
		"potions", -- removes ambro
		"credits", -- disabled in credits

		-- very not sure, ig not:
		-- "trappier_traps",
		-- "alternate_biomes",
	}
}

return modules
