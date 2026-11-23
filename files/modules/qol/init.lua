local hooks = {} ---@type hooks
local _g = HARDMOD_GLOBAL_DATA
local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local dir = utils.module_dir.."qol/"

local nxml = dofile_once("mods/noita.hardmod/lib/nxml.lua") ---@type nxml


ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/noita.hardmod/files/modules/qol/status_list_append.lua")

hooks.player_changed = function()
	if not _g.player_poly_identity then return end

	if not EntityGetFirstComponentIncludingDisabled(_g.player, "InventoryGuiComponent") then
		EntityAddComponent2(_g.player, "InventoryGuiComponent")
		EntityAddComponent2(_g.player, "LuaComponent", {
			script_source_file = "mods/noita.hardmod/files/modules/qol/polymorphed_player.lua"
		})
	end

	local polymorphs = {
		POLYMORPH = {
			icon = "mods/noita.hardmod/files/modules/qol/status_icons/polymorphed.png",
			name = "$hardmod_status_polymorph_name",
			desc = "$hardmod_status_polymorph_desc",
		},
		POLYMORPH_UNSTABLE = {
			icon = "mods/noita.hardmod/files/modules/qol/status_icons/chaotic_polymorphed.png",
			name = "$hardmod_status_unstable_polymorph_name",
			desc = "$hardmod_status_unstable_polymorph_desc",
		},
		POLYMORPH_RANDOM = {
			icon = "mods/noita.hardmod/files/modules/qol/status_icons/chaotic_polymorphed.png",
			name = "$hardmod_status_chaotic_polymorph_name",
			desc = "$hardmod_status_chaotic_polymorph_desc",
		},
	}

	if utils.MatchDateLocal({month = 3, day = 31}) then
		polymorphs.POLYMORPH.desc = "$hardmod_status_polymorph_trans_day"
	end

	local rare_polymorph = {
		icon = "mods/noita.hardmod/files/modules/qol/rare_chaotic_polymorphed.png",
		name = "$hardmod_status_rare_polymorph_name",
		desc = "$hardmod_status_rare_polymorph_desc",
	}

	for _,rare_poly in pairs(PolymorphTableGet(true)) do
		if _g.player_poly_identity.path == rare_poly then
			local is_rare = true
			for _,common_poly in pairs(PolymorphTableGet(false)) do
				if _g.player_poly_identity.path == common_poly then
					is_rare = false
					break
				end
			end
			if is_rare then polymorphs.POLYMORPH_RANDOM = rare_polymorph end
			break
		end
	end

	for game_effect,data in pairs(polymorphs) do
		local ge_comp = GameGetGameEffect(_g.player, game_effect)
		if ge_comp ~= 0 then
			local ge_entity = ComponentGetEntity(ge_comp)
			local is_perk = false
			if ComponentGetValue2(ge_comp, "frames") < 0 then is_perk = true end
			EntityAddComponent2(ge_entity, "UIIconComponent", {
				icon_sprite_file = data.icon,
				name = data.name,
				description = data.desc,
				is_perk = is_perk
			})
		end
	end
end

local ven_curse = {
	name = "$damage_hitfx_curse",
	description = "$hardmod_statusdesc_venomous_curse",
	icon_sprite_file = dir.."status_icons/venomous_curse.png",
	is_perk = "0"
}

local pregen_status_data = {}
dofile_once("data/scripts/status_effects/status_list.lua")

---@diagnostic disable-next-line: undefined-global
for _,status in ipairs(status_effects) do
	pregen_status_data[status.id] = {
		name = status.ui_name,
		description = status.ui_description,
		icon_sprite_file = status.ui_icon,
		is_perk = "0"
	}
end

local targets = {
	--THROWERS
	{
		path = "data/entities/misc/fireball_ray_enemy.xml",
		attr = {
			name = "$hardmod_statusname_fireball_thrower",
			description = "$hardmod_statusdesc_fireball_thrower",
			icon_sprite_file = "data/ui_gfx/status_indicators/fireball_ray.png",
			--display_above_head = 0, --defaults
			--display_in_hud = 1,
			is_perk = "0"
		}
	},
	{
		path = "data/entities/misc/lightning_ray_enemy.xml",
		attr = {
			name = "$hardmod_statusname_lightning_thrower",
			description = "$hardmod_statusdesc_lightning_thrower",
			icon_sprite_file = dir.."status_icons/lightning_thrower.png",
			is_perk = "0"
		}
	},
	{
		path = "data/entities/misc/tentacle_ray_enemy.xml",
		attr = {
			name = "$action_tentacle_ray",
			description = "$hardmod_statusdesc_tentacler",
			icon_sprite_file = dir.."status_icons/tentacler.png",
			is_perk = "0"
		}
	},

	--EXISTING STATUS EFFECTS
	{
		path = "data/entities/misc/effect_apply_wet.xml",
		attr = pregen_status_data.WET
	},
	{
		path = "data/entities/misc/effect_apply_oiled.xml",
		attr = pregen_status_data.OILED
	},
	{
		path = "data/entities/misc/effect_apply_bloody.xml",
		attr = pregen_status_data.BLOODY
	},
	{
		path = "data/entities/misc/effect_apply_poison.xml",
		attr = pregen_status_data.POISONED
	},
	{
		path = "data/entities/misc/effect_charm_short.xml",
		attr = pregen_status_data.CHARM
	},
	{
		path = "data/entities/misc/effect_invisibility_short.xml",
		attr = pregen_status_data.INVISIBILITY
	},
	{
		path = "data/entities/misc/effect_apply_on_fire.xml",
		attr = pregen_status_data.ON_FIRE
	},
	{
		path = "data/entities/misc/effect_protection_all_short_evil.xml",
		attr = pregen_status_data.PROTECTION_ALL
	},
	{
		path = "data/entities/misc/effect_protection_all_short.xml",
		attr = pregen_status_data.PROTECTION_ALL
	},
	{
		path = "data/entities/misc/effect_protection_all_ultrashort.xml",
		attr = pregen_status_data.PROTECTION_ALL
	},

	--VENOMOUS CURSE
	{
		path = "data/entities/misc/curse_init.xml",
		attr = ven_curse
	},
	{
		path = "data/entities/misc/curse_strong_init.xml",
		attr = ven_curse
	},
	{
		path = "data/entities/misc/curse_stronger_init.xml",
		attr = ven_curse
	},

	--MISC
	{
		path = "data/entities/misc/effect_necromancy.xml",
		attr = {
			name = "$hardmod_statusname_necromancy",
			description = "$hardmod_statusdesc_necromancy",
			icon_sprite_file = dir.."status_icons/necromancy.png",
			is_perk = "0"
		}
	},
	{
		path = "data/entities/misc/gravity_field_enemy.xml",
		attr = {
			name = "$hardmod_statusname_gravity_field",
			description = "$hardmod_statusdesc_gravity_field",
			icon_sprite_file = "data/ui_gfx/status_indicators/gravity_field.png",
			is_perk = "0"
		}
	},
}

for _,target in ipairs(targets) do
	for xml in nxml.edit_file(target.path) do
		if not xml:first_of("UIIconComponent") then
			xml:add_child(nxml.new_element("UIIconComponent", target.attr))
		end
	end
end


--these have `is_perk="1"` which disables the timer, removes it.
local not_perk_targets = {
	"data/entities/misc/curse_wither_projectile.xml",
	"data/entities/misc/curse_wither_explosion.xml",
	"data/entities/misc/curse_wither_melee.xml",
	"data/entities/misc/curse_wither_electricity.xml",
}

for _,target in ipairs(not_perk_targets) do
	for xml in nxml.edit_file(target) do
		local ui_icon_comp = xml:first_of("UIIconComponent")
		if ui_icon_comp then
			ui_icon_comp.attr.is_perk = "0"
		end
	end
end


for xml in nxml.edit_file("data/entities/misc/effect_no_heal_in_meat_biome.xml") do
	xml:add_child(nxml.new_element("LuaComponent", {
		script_biome_entered = dir.."meat_curse/meat_realm_curse.lua"
	}))
end


return hooks