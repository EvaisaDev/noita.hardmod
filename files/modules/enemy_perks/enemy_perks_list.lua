---@class enemy_perk
---@field id string string ID
---@field name string string name (viewable in progress)
---@field description string? description of the perk (viewable in progress)
---@field sprite string? path to the perk's sprite
---@field icon string? path to the perk's icon
---@field not_progress boolean? if true, perk won't show up in progress menu
---@field weight number? probability of the perk being pulled, default 10
---@field priority number? priority for the order its shown above enemies' heads or in the inspect window, default 10
---@field max int? max number of this perk an enemy can have
---@field condition function? if added, this function must return true, is passed the `data` table
---@field func function function that actually does the stuff, is passed the `data` table

local sprites_path = "mods/noita.hardmod/files/modules/enemy_perks/perk_sprites/"
local icons_path = "mods/noita.hardmod/files/modules/enemy_perks/perk_icons/"

local enemy_is_ranged = function(self, data)
	local animal_ai_comp = EntityGetFirstComponentIncludingDisabled(data.target_enemy,"AnimalAIComponent")
	if animal_ai_comp and ComponentGetValue2(animal_ai_comp,"attack_ranged_enabled") then
		return true
	end
end

-- The `data` table provides `target_enemy` (eid), `already_held_perks` (perk_id[]), `player` (eid) and `player_poly_identity` (table)

---@type enemy_perk[]
local perks = {
	--[[
	{
		id = "TEST_PERK",
		name = "$hardmod_enemy_perks_test",
		description = "Wow, what a great test perk!",
		weight = 10,
		condition = function(self, data) end,
		func = function(self, holder, perk_entity)
			GetGameEffectLoadTo(holder, "REGENERATION", true)
		end
	},--]]
	{
		id = "LAVA_BLOOD",
		name = "$hardmod_eperk_lava_blood_name",
		description = "$hardmod_eperk_lava_blood_desc",
		weight = 3,
		priority = 5,
		max = 1,
		condition = function(self, data)
			return not data.blood_perk
		end,
		func = function(self, entity_id, data)
			local dmc = EntityGetFirstComponent(entity_id, "DamageModelComponent")
			if not dmc then return end

			ComponentSetValue2(dmc, "blood_material", "lava")
			ComponentSetValue2(dmc, "blood_spray_material", "lava")
			ComponentSetValue2(dmc, "wet_status_effect_damage", 0.1)
			EntitySetDamageFromMaterial(entity_id, "water", 0.0002)
			EntitySetDamageFromMaterial(entity_id, "mud", 0.0002)
			EntitySetDamageFromMaterial(entity_id, "water_swamp", 0.0002)
			EntitySetDamageFromMaterial(entity_id, "water_salt", 0.0002)
			EntitySetDamageFromMaterial(entity_id, "swamp", 0.0002)
			EntitySetDamageFromMaterial(entity_id, "snow", 0.0002)
			EntitySetDamageFromMaterial(entity_id, "water_ice", 0.0002)

			EntitySetDamageFromMaterial(entity_id, "lava", 0)
			GetGameEffectLoadTo(entity_id, "PROTECTION_FIRE", false)

			data.blood_perk = "lava" --do this for condition func so multiple blood perks aren't rolled
		end
	},
	{
		id = "KAMIKAZE",
		name = "$hardmod_eperk_kamikaze_name",
		description = "$hardmod_eperk_kamikaze_desc",
		weight = 2,
		priority = 20,
		max = 1,
		condition = enemy_is_ranged,
		func = function(self, entity_id, data)
			-- show nuke particles on the enemy
			local x, y = EntityGetTransform(entity_id)
			EntityAddChild(entity_id, EntityLoad( "mods/noita.hardmod/files/modules/enemy_perks/entities/kamikaze_particles.xml", x, y))

			-- make the enemy explode on death
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_death = "mods/noita.hardmod/files/modules/enemy_perks/scripts/kamikaze_on_death.lua",
				execute_every_n_frame = -1,
			})

			-- make the enemy explode when near the player
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_source_file = "mods/noita.hardmod/files/modules/enemy_perks/scripts/kamikaze_update.lua",
				execute_every_n_frame = 1,
			})
		end
	},
	{
		id = "PROTECTOR",
		name = "$hardmod_eperk_protector_name",
		description = "$hardmod_eperk_protector_desc",
		weight = 3,
		max = 1,
		condition = function(self, data)
			local dmg_comp = EntityGetFirstComponentIncludingDisabled( data.target_enemy, "DamageModelComponent" )
			if dmg_comp ~= nil then
				local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )
				if max_hp >= 2 then
					return true
				end
			end
		end,
		func = function(self, entity_id, data)
			local x, y = EntityGetTransform(entity_id)
			EntityAddChild(entity_id, EntityLoad( "mods/noita.hardmod/files/modules/enemy_perks/entities/protector_shield.xml", x, y))
		end
	},
	-- {
	-- 	id = "IMPERVIOUS",
	-- 	name = "$hardmod_eperk_impervious_name",
	-- 	description = "$hardmod_eperk_impervious_desc",
	-- 	weight = 1,
	-- 	max = 1,
	-- 	func = function(self, entity_id, data)
	-- 		local x, y = EntityGetTransform(entity_id)
	-- 		EntityAddChild(entity_id, EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/entities/impervious_shield.xml", x, y))

	-- 		local dmg_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
	-- 		if dmg_comp ~= nil then
	-- 			ComponentObjectSetValue2(dmg_comp, "damage_multipliers", "projectile", 0.0)
	-- 			ComponentObjectSetValue2(dmg_comp, "damage_multipliers", "melee", 1000.0)
	-- 		end			
	-- 	end
	-- },
	{
		id = "DRY_SPELL",
		name = "$hardmod_eperk_dry_spell_name",
		description = "$hardmod_eperk_dry_spell_desc",
		weight = 2,
		max = 1,
		func = function(self, entity_id, data)
			local x, y = EntityGetTransform(entity_id)
			EntityAddChild(entity_id, EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/entities/dry_spell.xml", x, y))
		end
	},
	{
		id = "THUNDERLORD",
		name = "$hardmod_eperk_thunderlord_name",
		description = "$hardmod_eperk_thunderlord_desc",
		weight = 1,
		priority = 7,
		max = 1,
		condition = enemy_is_ranged,
		func = function(self, entity_id, data)
			GetGameEffectLoadTo(entity_id, "PROTECTION_ELECTRICITY", true)
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_shot = "mods/noita.hardmod/files/modules/enemy_perks/scripts/thunderlord_on_shot.lua",
				execute_every_n_frame = -1,
			})
		end
	},
	{
		id = "PYRELORD",
		name = "$hardmod_eperk_pyrelord_name",
		description = "$hardmod_eperk_pyrelord_desc",
		weight = 3,
		max = 1,
		condition = function(self, data)
			local comp = EntityGetFirstComponentIncludingDisabled(data.target_enemy, "AnimalAIComponent")
			if comp and ComponentGetValue2(comp, "attack_ranged_enabled") then
				return true
			end
		end,
		func = function(self, entity_id, data)
			GetGameEffectLoadTo(entity_id, "PROTECTION_FIRE", true)
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_shot = "mods/noita.hardmod/files/modules/enemy_perks/scripts/pyrelord_on_shot.lua",
				execute_every_n_frame = -1,
			})
		end
	},
	{
		id = "VIGOUR",
		name = "$hardmod_eperk_vigour_name",
		description = "$hardmod_eperk_vigour_desc",
		weight = 1,
		priority = 15,
		max = 1,
		-- condition = function(self, data)
		-- -- @UserK how does this workkk
		-- 	if data.how_many_of_each_perk["HARDMOD_KAMIKAZE"] == 0 then return true end
		-- end,
		func = function(self, entity_id, data)
			-- make the enemy explode on death
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_death = "mods/noita.hardmod/files/modules/enemy_perks/scripts/vigour_on_death.lua",
				execute_every_n_frame = -1,
			})
		end
	},
	{
		id = "MAGIC_RESISTANCE",
		name = "$hardmod_eperk_magic_resistance_name",
		description = "$hardmod_eperk_magic_resistance_desc",
		weight = 3,
		func = function(self, entity_id, data)
			local dmc = EntityGetFirstComponent(entity_id, "DamageModelComponent")
			if not dmc then return end

			ComponentObjectSetValue2(dmc, "damage_multipliers", "projectile",
				ComponentObjectGetValue2(dmc, "damage_multipliers", "projectile") * .5
			)
		end
	},
	{
		id = "AEROLORD",
		name = "$hardmod_eperk_aerolord_name",
		description = "$hardmod_eperk_aerolord_desc",
		sprite = sprites_path.."aerolord.png",
		weight = 0.5,
		max = 1,
		condition = function(self, data)
			if data.level < 5 then return false end

			local comp = EntityGetFirstComponentIncludingDisabled(data.target_enemy, "AnimalAIComponent")
            if comp and ComponentGetValue2(comp, "attack_ranged_enabled") then
            	return true
            end
		end,
		func = function(self, entity_id, data)
			GetGameEffectLoadTo(entity_id, "KNOCKBACK_IMMUNITY", true)
			EntityAddComponent2(entity_id, "LuaComponent", {
	            script_shot = "mods/noita.hardmod/files/modules/enemy_perks/scripts/aerolord_on_shot.lua",
				execute_every_n_frame = -1,
            })
		end
	},
  {
		id = "EXTRA_HP",
		name = "$hardmod_eperk_extra_hp_name",
		description = "$hardmod_eperk_extra_hp_desc",
		weight = 1,
		func = function(self, entity_id, data)
			local dmc = EntityGetFirstComponent(entity_id, "DamageModelComponent")
			if not dmc then return end

			ComponentSetValue2(dmc, "max_hp", ComponentGetValue2(dmc, "max_hp") * 1.5)
			ComponentSetValue2(dmc, "hp", ComponentGetValue2(dmc, "hp") * 1.5)
		end
	},
	{
		id = "POISON_BLOOD",
		name = "$hardmod_eperk_poison_blood_name",
		description = "$hardmod_eperk_poison_blood_desc",
		weight = 3,
		priority = 5,
		max = 1,
		condition = function(self, data) return not data.blood_perk end,
		func = function(self, entity_id, data)
			local dmc = EntityGetFirstComponent(entity_id, "DamageModelComponent")
			if not dmc then return end

			ComponentSetValue2(dmc, "blood_material", "poison")
			ComponentSetValue2(dmc, "blood_spray_material", "poison")
			EntitySetDamageFromMaterial(entity_id, "poison", 0)
			ComponentObjectSetValue2(dmc, "damage_multipliers", "poison", 0)

			data.blood_perk = "poison" --do this for condition func so multiple blood perks aren't rolled
		end
	},
	{
		id = "COLD_BLOOD",
		name = "$hardmod_eperk_cold_blood_name",
		description = "$hardmod_eperk_cold_blood_desc",
		weight = 3,
		priority = 4,
		max = 1,
		condition = function(self, data) return not data.blood_perk end,
		func = function(self, entity_id, data)
			local dmc = EntityGetFirstComponent(entity_id, "DamageModelComponent")
			if not dmc then return end

			ComponentSetValue2(dmc, "blood_material", "blood_cold")
			ComponentSetValue2(dmc, "blood_spray_material", "blood_cold")
			EntitySetDamageFromMaterial(entity_id, "blood_cold", 0)
			EntitySetDamageFromMaterial(entity_id, "blood_cold_vapour", 0)

			data.blood_perk = "blood_cold" --do this for condition func so multiple blood perks aren't rolled
		end
	},
	{
		id = "CURSER",
		name = "$hardmod_eperk_curser_name",
		description = "$hardmod_eperk_curser_desc",
		weight = 1,
		priority = 4,
		max = 1,
		condition = function(self, data)
			return enemy_is_ranged(self, data) and data.level > 3
		end,
		func = function(self, entity_id, data)
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_shot = "mods/noita.hardmod/files/modules/enemy_perks/scripts/curser_shot.lua",
				execute_every_n_frame = -1,
			})
		end
	},
	{ --I'll implement this later, or someone can do it for me 🙏
		not_progress = true,
		id = "VENOMOUS_CURSER",
		name = "$hardmod_eperk_venomous_curser_name",
		description = "$hardmod_eperk_venomous_curser_desc",
		weight = 0,
		priority = 0,
		max = 0,
		condition = enemy_is_ranged,
		func = function(self, entity_id, data)
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_shot = "mods/noita.hardmod/files/modules/enemy_perks/scripts/venomous_curser_shot.lua",
				execute_every_n_frame = -1,
			})
		end
	},
	{
		id = "RECYCLE_HEALTH",
		name = "$hardmod_eperk_recycle_health_name",
		description = "$hardmod_eperk_recycle_health_desc",
		weight = 2,
		priority = 0,
		max = 0,
		func = function(self, entity_id, data)
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_damage_received = "mods/noita.hardmod/files/modules/enemy_perks/scripts/recycle_health.lua",
			})
		end
	},
	{
		id = "WET_AURA",
		name = "$hardmod_eperk_wet_aura_name",
		description = "$hardmod_eperk_wet_aura_desc",
		weight = 5,
		priority = 0,
		max = 1,
		func = function(self, entity_id, data)
			EntityAddChild(entity_id, EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/entities/wet_aura.xml", data.x, data.y))
		end
	},
	{ -- TODO: Someone please nerf this??
		id = "BLACKHOLE_DEATH",
		name = "$hardmod_eperk_blackhole_death_name",
		description = "$hardmod_eperk_blackhole_death_desc",
		weight = 0.1,
		priority = 0,
		max = 1,
		condition = function(self, data) return data.level > 6 end,
		func = function(self, entity_id, data)
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_death = "mods/noita.hardmod/files/modules/enemy_perks/scripts/spawn_giga_blackhole.lua"
			})
		end
	},
	{
		id = "SKULLFLYS",
		name = "$hardmod_eperk_skullflys_name",
		description = "$hardmod_eperk_skullflys_desc",
		weight = 0.1,
		priority = 0,
		max = 3,
		condition = function(self, data) return data.level > 4 end,
		func = function(self, entity_id, data)
			-- I made them spawn small skullflys instead, that was way too much
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_death = "mods/noita.hardmod/files/modules/enemy_perks/scripts/add_skullflys.lua"
			})
		end
	},
	{ -- TODO: Someone please nerf this??
		id = "DAMAGE_BUFFER",
		name = "$hardmod_eperk_damage_buffer_name",
		description = "$hardmod_eperk_damage_buffer_desc",
		weight = 0.1,
		priority = 0,
		max = 1,
		condition = function(self, data) return data.level > 3 end,
		func = function(self, entity_id, data)
			EntityAddChild(entity_id, EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/entities/damage_buffer.xml", data.x, data.y))
		end
	},
}

for _,perk in ipairs(perks) do
	local id = perk.id
	perk.id = "HARDMOD_"..perk.id
	perk.name = perk.name or perk.id
	perk.weight = perk.weight or 10
	perk.priority = perk.priority or 0
	perk.sprite = ModDoesFileExist(perk.sprite or "") and perk.sprite
		or ModDoesFileExist(sprites_path..id:lower()..".png") and sprites_path..id:lower()..".png"
		or "mods/noita.hardmod/files/modules/enemy_perks/perk_sprites/missing.png"
	perk.icon = ModDoesFileExist(perk.icon or "") and perk.icon
		or ModDoesFileExist(icons_path..id:lower()..".png") and icons_path..id:lower()..".png"
		or "mods/noita.hardmod/files/modules/enemy_perks/perk_icons/missing.png"

	if perk.max then --This is sane enough.
		local cond = perk.condition or function(...) return true end
		perk.condition = function(self, data, ...)
			return cond(self, data, ...) and (data.how_many_of_each_perk[self.id] or 0) < self.max
		end
	end
end

return perks
