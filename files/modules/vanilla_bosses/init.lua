local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml
local root = "mods/noita.hardmod/files/modules/vanilla_bosses/"

ModLuaFileAppend("data/entities/animals/boss_pit/boss_pit_damage.lua", root.."appends/boss_pit_damage.lua")

ModMaterialsFileAdd(root.."materials.xml")

local edit = {
	["boss_centipede/boss_centipede"] = {
		damagecomp = { materials_damage = false },
		tags = { "touchmagic_immunity" },
	},
	["boss_dragon"] = {
		effects = { "STUN_PROTECTION_FREEZE" }
	},
	["boss_ghost/boss_ghost"] = {
		damagemult = { explosion = 0.3 }
	},
	["boss_alchemist/boss_alchemist"] = {
		from_base = true,
		damagemult = {
			explosion = 0.5,
			projectile = 0.2,
		}
	},
	["boss_gate/gate_monster_a"] = {
		damagecomp = { hp = 130 },
		damagemult = {
			projectile = 0.3,
			explosion = 0.3,
		}
	},
	["boss_meat/boss_meat"] = {
		effects = { "STUN_PROTECTION_FREEZE" },
		damagecomp = { hp = 80 },
		damagemult = {
			projectile = 0.3,
			explosion = 0.4,
			drill = 0.6,
			slice = 0.6,
		}
	}
}

for enemy,data in pairs(edit) do
	for f in nxml.edit_file("data/entities/animals/"..enemy..".xml") do
		local file = data.from_base and f:first_of("Base") or f

		if data.tags then
			local tags = file:get("tags")
			tags = tags and (tags..",") or ""
			file:set("tags", tags..table.concat(data.tags, ","))
		end

		if data.damagecomp then
			local dmc = file:first_of("DamageModelComponent")
			for k,v in pairs(data.damagecomp) do
				if dmc then dmc:set(k, v) end
			end
		end

		if data.damagemult then
			local dmc = file:first_of("DamageModelComponent"):first_of("damage_multipliers")
			for k,v in pairs(data.damagemult) do
				if dmc then dmc:set(k, v) end
			end
		end

		for _,effect in pairs(data.effects or {}) do
			local entity = file:create_child("Entity")

			entity:create_child("InheritTransformComponent")
			entity:create_child("GameEffectComponent", {
				effect = effect,
				frames = -1
			})
		end
	end
end

-- door boss
for file in nxml.edit_file("data/entities/animals/boss_gate/gate_monster_a.xml") do
	file:create_child("BossHealthBarComponent", { gui = false, in_world = true })

	file:create_child("SpriteComponent", {
		_tags = "health_bar_back,ui,no_hitbox",
		image_file = "data/ui_gfx/health_slider_back_meat.png",
		offset_x = 12, offset_y = 43, emissive = 1, never_ragdollify_on_death="1",
		update_transform_rotation = false,
		has_special_scale = true,
		z_index = -9000,
	})

	file:create_child("SpriteComponent", {
		_tags = "health_bar,ui,no_hitbox",
		image_file = "data/ui_gfx/health_slider_front.png",
		offset_x = 11, offset_y = 42, emissive = 1, never_ragdollify_on_death = "1",
		update_transform_rotation = false,
		has_special_scale = true,
		z_index = -9000,
	})

	file:first_of("PhysicsImageShapeComponent"):set("material", "hardmod_gate_boss_material")
	file:first_of("CellEaterComponent"):set("ignored_material", "hardmod_gate_boss_material")

	file:create_child("MagicConvertMaterialComponent", {
		-- from_any_material = true,
		from_material_array = "rock_hard,rock_hard_border,templerock_static,templebrick_static,templebrick_noedge_static,templebrick_thick_static,templebrickdark_static",
        to_material_array = "rock_static_cursed,rock_static_cursed,rock_static_cursed,rock_static_cursed,rock_static_cursed,rock_static_cursed,rock_static_cursed",
		-- to_material = "rock_static_cursed",
        loop = false, is_circle = true,
		kill_when_finished = false,
        steps_per_frame = 30,
        radius = 90,
    })
end

local gates = { "a", "b", "c", "d" }
for _,gate in pairs(gates) do
	for file in nxml.edit_file("data/entities/animals/boss_gate/gate_monster_"..gate..".xml") do
		file:create_child("Entity", {}, {
			nxml.new_element("Base", {
				file = "mods/noita.hardmod/files/modules/vanilla_bosses/entity/gate_boss_shield.xml"
			})
		})

		file:create_child("Entity", {}, {
			nxml.new_element("Base", {
				file = "mods/noita.hardmod/files/modules/vanilla_bosses/entity/gate_boss_shield_inner.xml"
			})
		})
	end
end

for file in nxml.edit_file("data/entities/buildings/wizardcave_gate_monster_spawner.xml") do
	file:first_of("CellEaterComponent"):set("ignored_material", "hardmod_gate_boss_material")
end

-- TODO: the boss needs rebalancing, fix cheeses, make it much harder to kill
utils.modifile(
	"data/entities/animals/boss_wizard/death.lua",
	[[EntityLoad( "data/entities/items/pickup/wandstone.xml"]],
	[[--]]
)

utils.patchifile("data/entities/animals/boss_gate/gate_monster_death.lua", {{
	from = [[AddFlagPersistent( "miniboss_gate_monsters" )]],
	insert_after = [[
		EntityLoad("data/entities/items/pickup/wandstone.xml", pos_x, pos_y)
		EntityLoad("mods/noita.hardmod/files/modules/vanilla_bosses/entity/wandstone_emitter.xml", pos_x, pos_y)
		GamePlaySound("data/audio/Desktop/projectiles.snd", "player_projectiles/crumbling_earth/create", pos_x, pos_y)	

		for _,flag in pairs({"a","b","c","d"}) do GameRemoveFlagRun("$animal_gate_monster_"..flag.."_killed") end
	]]
}})

return {}
