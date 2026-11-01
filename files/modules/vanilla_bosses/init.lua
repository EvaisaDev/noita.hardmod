local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml
local root = "mods/noita.hardmod/files/modules/vanilla_bosses/"

ModLuaFileAppend("data/entities/animals/boss_pit/boss_pit_damage.lua", root.."appends/boss_pit_damage.lua")

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
		damagemult = { explosion = 0.6 }
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
