local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local hooks = {}---@type perk_hooks
local dir = "mods/noita.hardmod/files/modules/vanilla_perk_rebalances/"

hooks.new_perks = {
	{
		id = "HARDMOD_SPELL_GEMS",
		insert_after = "ANGRY_LEVITATION",
		author = "$modder.dani2d",
		ui_name = "$hardmod_perk_spell_gems_name",
		ui_description = "$hardmod_perk_spell_gems_desc",
		ui_icon = dir.."ui_gfx/perks/spell_gems_016.png",
		perk_icon = dir.."ui_gfx/perks/spell_gems.png",
		stackable = false,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
			-- nothing happens
		end
	},
	{
		id = "HARDMOD_TINKER_AT_PEDESTALS",
		insert_after = "WAND_EXPERIMENTER",
		author = "$modder.dani2d",
		ui_name = "$hardmod_perk_tinker_at_pedestals_name",
		ui_description = "$hardmod_perk_tinker_at_pedestals_desc",
		ui_icon = dir.."ui_gfx/perks/tinker_at_pedestals_016.png",
		perk_icon = dir.."ui_gfx/perks/tinker_at_pedestals.png",
		stackable = false,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
			if pickup_count > 1 then return end
			EntityAddChild(entity_who_picked, EntityLoad(dir.."entities/effect_tinker_at_pedestals.xml"))
		end
	},
	{
		id = "HARDMOD_PROTECTION_ELECTRIC_STUN",
		insert_after = "PROTECTION_ELECTRICITY",
		ui_name = "$hardmod_perk_protection_electric_stun_name",
		ui_description = "$hardmod_perk_protection_electric_stun_desc",
		ui_icon = dir.."ui_gfx/perks/protection_electric_stun_016.png",
		perk_icon = dir.."ui_gfx/perks/protection_electric_stun.png",
		game_effect = "STUN_PROTECTION_ELECTRICITY",
		stackable = false,
		one_off_effect = false,
		usable_by_enemies = false,
		-- given from altar sacrifice
		not_in_default_perk_pool = true,
	},
	{
		id = "HARDMOD_PROTECTION_FREEZE",
		insert_after = "PROTECTION_ELECTRICITY",
		ui_name = "$perk_protection_freeze",
		ui_description = "$perkdesc_protection_freeze",
		ui_icon = "data/ui_gfx/perk_icons/protection_freeze.png",
		perk_icon = "data/items_gfx/perks/protection_freeze.png",
		game_effect = "STUN_PROTECTION_FREEZE",
		stackable = false,
		one_off_effect = false,
		usable_by_enemies = false,
		-- given from altar sacrifice
		not_in_default_perk_pool = true,
	},
	{
		id = "HARDMOD_ITEM_IMMUNITIES",
		insert_after = "ABILITY_ACTIONS_MATERIALIZED",
		author = "$modder.yui",
		ui_name = "$hardmod_perk_item_immunities_name",
		ui_description = "$hardmod_perk_item_immunities_desc",
		ui_icon = dir.."ui_gfx/perks/item_immunities_016.png",
		perk_icon = dir.."ui_gfx/perks/item_immunities.png",
		stackable = false,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function(perk, player, name, count)
			if count > 1 then return end
			EntityAddChild(player, EntityLoad(dir.."entities/effect_item_immunities.xml"))
		end
	},
	{ --Nabbed from Apotheosis
		id = "HARDMOD_OVERSIZED_SHIELD",
		insert_after = "SHIELD",
		author = "$modder.conga",
		ui_name = "$hardmod_perk_oversized_shield_name",
		ui_description = "$hardmod_perk_oversized_shield_desc",
		ui_icon = dir.."ui_gfx/perks/shield_oversized_016.png",
		perk_icon = dir.."ui_gfx/perks/shield_oversized.png",
		stackable = true,
		stackable_how_often_reappears = 10,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		usable_by_enemies = false,
		func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
			local x, y = EntityGetTransform(entity_who_picked)
			local child_id = EntityLoad(dir.."entities/perks/shield_oversized.xml", x, y)

			if ModIsEnabled("quant.ew") then
				GlobalsSetValue("PERK_SHIELD_OVERSIZED_COUNT", tostring(pickup_count-1))
			end
			local shield_num = tonumber(GlobalsGetValue("PERK_SHIELD_OVERSIZED_COUNT", "0"))
			local shield_radius = 75 + shield_num * 3.0
			local charge_speed = math.max(0.01 - shield_num * 0.05, 0.02)
			shield_num = shield_num + 1
			GlobalsSetValue("PERK_SHIELD_OVERSIZED_COUNT", tostring(shield_num))

			local comps = EntityGetComponent(child_id, "EnergyShieldComponent")
			for i,comp in ipairs(comps or {}) do
				ComponentSetValue2(comp, "radius", shield_radius)
				ComponentSetValue2(comp, "recharge_speed", charge_speed)
			end

			comps = EntityGetComponent(child_id, "ParticleEmitterComponent")
			for i,comp in ipairs(comps or {}) do
				local minradius,maxradius = ComponentGetValue2(comp, "area_circle_radius")

				if minradius and maxradius then
					if minradius == 0 then
						ComponentSetValue2(comp, "area_circle_radius", 0, shield_radius)
					elseif minradius == 10 then
						ComponentSetValue2(comp, "area_circle_radius", shield_radius, shield_radius)
					end
				end
			end

			EntityAddTag(child_id, "perk_entity")
			EntityAddChild(entity_who_picked, child_id)
		end,
		func_remove = function()
			local shield_num = 0
			GlobalsSetValue("PERK_SHIELD_OVERSIZED_COUNT", tostring(shield_num))
		end,
	},
	{
		id = "HARDMOD_SUMMON_TOOLBOX",
		insert_after = "EXTRA_MANA",
		author = "$modder.dani2d",
		ui_name = "$hardmod_perk_summon_toolbox_name",
		ui_description = "$hardmod_perk_summon_toolbox_desc",
		ui_icon = dir.."ui_gfx/perks/summon_toolbox_016.png",
		perk_icon = dir.."ui_gfx/perks/summon_toolbox.png",
		stackable = false,
		one_off_effect = true,
		usable_by_enemies = false,
		func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
			if pickup_count > 1 then return end

			local x, y = EntityGetTransform(entity_who_picked)
			local toolbox_id = EntityLoad(dir.."entities/items/toolbox.xml", x, y - 8)
			EntityAddComponent2(toolbox_id, "LuaComponent", {
				_tags = "enabled_in_hand,enabled_in_inventory",
				script_source_file = dir.."scripts/perks/toolbox_scan.lua",
				execute_every_n_frame = 60,
			})
		end,
	},
	{
		id = "HARDMOD_PYROMANIAC",
		insert_after = "ELECTRICITY",
		author = "$modder.yui",
		ui_name = "$hardmod_perk_pyromaniac_name",
		ui_description = "$hardmod_perk_pyromaniac_desc",
		ui_icon = dir.."ui_gfx/perks/pyromaniac_016.png",
		perk_icon = dir.."ui_gfx/perks/pyromaniac.png",
		stackable = false,
		one_off_effect = false,
		usable_by_enemies = false,
		remove_other_perks = { "PROTECTION_FIRE" },
		func = function(perk, entity, name)
			local x, y = EntityGetTransform(entity)
			local effect = EntityLoad(dir.."entities/effect_pyromaniac.xml", x, y)
			EntityAddChild(entity, effect)
		end
	},
	{
		--temp vars to make this appear via poopstone sacrifice until this perk is reworked
		not_in_default_perk_pool = true,
		not_progress = true,
		hardmod_shit_perk = true,

		id = "HARDMOD_EMERGENCY_RECALL",
		ui_name = "$hardmod_perk_emergency_recall_name",
		ui_description = "$hardmod_perk_emergency_recall_desc",
		ui_icon = dir.."ui_gfx/perks/teleportitis_016.png",
		perk_icon = dir.."ui_gfx/perks/teleportitis.png",
		stackable = false,
		usable_by_enemies = false,
		func = function(entity_perk_item, entity_who_picked, item_name)
			EntityAddComponent2(entity_who_picked, "LuaComponent", {
				_tags = "perk_component,hardmod_teleportitis",
				script_source_file = dir.."scripts/perks/teleportitis_update.lua",
				execute_every_n_frame = 1,
			})
			EntityAddComponent2(entity_who_picked, "LuaComponent", {
				_tags = "perk_component,hardmod_teleportitis",
				script_damage_received = dir.."scripts/perks/teleportitis_on_damage.lua",
				execute_every_n_frame = -1,
			})
		end,
		func_remove = function(entity_who_picked)
			utils.EntityRemoveAllByTag(entity_who_picked, "hardmod_teleportitis")
		end,
	},
	{
		id = "HARDMOD_GOLD_IS_DUST",
		insert_after = "GOLD_IS_FOREVER",
		author = "$modder.userk",
		ui_name = "$hardmod_gold_is_dust_perkname",
		ui_description = "$hardmod_gold_is_dust_perkdesc",
		perk_icon = dir.."gold_is_dust/perk.png",
		ui_icon = dir.."gold_is_dust/icon.png",
		stackable = false,
		usable_by_enemies = false,
		func = function()
			GameAddFlagRun("hardmod.gold_is_dust_perk")
		end,
		func_remove = function()
			GameRemoveFlagRun("hardmod.gold_is_dust_perk")
		end,
	},
	{
		id = "HARDMOD_PROMOTE_SPELL",
		insert_after = "ALWAYS_CAST",
		ui_name = "$hardmod_perk_promote_random_spell_name",
		ui_description = "$hardmod_perk_promote_random_spell_desc",
		ui_icon = dir.."ui_gfx/perks/promote_random_spell_016.png",
		perk_icon = dir.."ui_gfx/perks/promote_random_spell.png",
		stackable = true,
		one_off_effect = true,
		usable_by_enemies = false,
		func = function(perk_entity, taker, perk_name)
			local x, y = EntityGetTransform(perk_entity)
			local wand = utils.GetHeldWand(taker)
			if not wand then
				GamePrintImportant("$hardmod_promote_ac_fail_empty", "$logdesc_d2d_promote_ac_fail_no_wands")
				GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/chest_bad/create", x, y)
				return
			end --no wands found

			local max_allowed_always_casts = 4 --in case we want to change this
			local promotion_range = 5

			local ability_component = EntityGetFirstComponentIncludingDisabled(wand, "AbilityComponent")
			if not ability_component then return end --wand fail bs

			local always_casts = ComponentObjectGetValue2(ability_component, "gun_config", "deck_capacity") - EntityGetWandCapacity(wand)
			if always_casts >= max_allowed_always_casts then
				GamePrintImportant("$hardmod_promote_ac_fail", "$hardmod_promote_ac_fail_capped")
				GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/chest_bad/create", x, y)
				return
			end

			local unique_inv_spells = {}
			local logged_spells = {}
			local children = EntityGetAllChildren(taker)
			for _,child in ipairs(children or {}) do
				if EntityGetName(child) == "inventory_full" then
					for _,item in ipairs(EntityGetAllChildren(child) or {}) do
						local ia_component = EntityGetFirstComponentIncludingDisabled(item, "ItemActionComponent")
						if ia_component then
							local spell_id = ComponentGetValue2(ia_component, "action_id")
							if not logged_spells[spell_id] then
								logged_spells[spell_id] = true
								unique_inv_spells[#unique_inv_spells+1] = item
							end
						end
					end
				end
			end

			local spells_blacklist = {
				["HARDMOD_UPGRADE_CAPACITY"] = true,
				["HARDMOD_UPGRADE_FIRE_RATE"] = true,
				["HARDMOD_UPGRADE_MAX_MANA"] = true,
				["HARDMOD_UPGRADE_MANA_CHARGE_SPEED"] = true,
				["HARDMOD_UPGRADE_REMOVE_ALWAYS_CAST"] = true,
				["HARDMOD_UPGRADE_SPREAD"] = true,
			}

			local spells = {}
			for _,item in ipairs(unique_inv_spells) do
				local ia_comp = EntityGetFirstComponentIncludingDisabled(item, "ItemActionComponent")
				if ia_comp then
					local sid = ComponentGetValue2(ia_comp, "action_id")
					if not spells_blacklist[sid] then spells[#spells+1] = { eid = item, sid = sid } end
				end
			end

			if #spells == 0 then
				GamePrintImportant("$hardmod_promote_ac_fail_empty", "$hardmod_promote_ac_fail_no_spells")
				GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/chest_bad/create", x, y)
				return
			end

			spells = utils.ShuffleTable(spells)

			local target = spells[Random(1, promotion_range)]
			if target == nil then
				local absolute_fail_chance = string.format("%s%%", (1-#spells/promotion_range)*100)
				GamePrintImportant("$hardmod_promote_ac_fail", GameTextGet("$hardmod_promote_ac_fail_unlucky", absolute_fail_chance))
				GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/chest_bad/create", x, y)
			else
				local indexed_gun_actions = dofile_once("mods/noita.hardmod/lib/gun_actions_indexed.lua")
				GamePrint(GameTextGet("$hardmod_promot_ac_success", GameTextGetTranslatedOrNot(indexed_gun_actions[target.sid].name)))

				EntityRemoveFromParent(target.eid)
				EntityAddChild(wand, target.eid)

				local deck_capacity = ComponentObjectGetValue2(ability_component, "gun_config", "deck_capacity")
				deck_capacity = deck_capacity + 1
				ComponentObjectSetValue2(ability_component, "gun_config", "deck_capacity", deck_capacity)
				local item_component = EntityGetFirstComponentIncludingDisabled(target.eid, "ItemComponent")
				if item_component then
					ComponentSetValue2(item_component, "permanently_attached", true)
				end

				EntitySetComponentsWithTagEnabled(target.eid, "enabled_in_world", false)
			end
		end
	},
}

hooks.perk_patches = {
	["PROJECTILE_HOMING"] = {
		-- Reimplement this as a ShotEffectComponent for the Inhibitor spell
		-- (i am NOT making it support game effects) -Y
		-- lmaoooo -K
		game_effect = "NONE",
		func = function(perk, player)
			EntityAddComponent2(player, "ShotEffectComponent", {
				_tags = "perk_component",
				extra_modifier = "projectile_homing",
			})
		end
	},
	["REMOVE_FOG_OF_WAR"] = { not_in_default_perk_pool = true },
	["SHIELD"] = { stackable_maximum = 3 },
	["ABILITY_ACTIONS_MATERIALIZED"] = { --works with most spells now, not just a specific selection of bomb spells
		ui_name = "$hardmod_spells_materialised_perkname",
		ui_description = "$hardmod_spells_materialised_perkdesc",
		perk_icon = dir.."spells_materialised/perk.png",
		ui_icon = dir.."spells_materialised/icon.png",
	},
	["EXTRA_MANA"] = { --buff mana slightly, change 50% decrease in capacity to flat decrease 1-3 plus 10% of current capacity rounded down
		ui_description = "$hardmod_extra_mana_perkdesc",
		func = function(perk, taker, perk_name)
			local wand = utils.GetHeldWand(taker)
			if not wand then return end
			local x, y = EntityGetTransform(wand)

			local ability_comp = EntityGetFirstComponentIncludingDisabled(wand, "AbilityComponent")
			if not ability_comp then return end

			local mana_max = ComponentGetValue2(ability_comp, "mana_max")
			local mana_charge = ComponentGetValue2(ability_comp, "mana_charge_speed")
			local full_capacity = ComponentObjectGetValue2(ability_comp, "gun_config", "deck_capacity") --include ACs
			local capacity = EntityGetWandCapacity(wand) --do not include ACs
			local always_cast_count = math.max(0, full_capacity - capacity)

			local perk_x, perk_y =  EntityGetTransform(perk)
			SetRandomSeed(perk_x, perk_y)

			--lesser of (multiply by 1.3-1.5 OR add 100-500), plus random 100-500
			mana_max = math.min(mana_max * Randomf(1.3, 1.5), mana_max + Random(100, 500))   + Random(100, 200)
			mana_max = math.floor(math.min(mana_max, 50000)) --max of 50k

			--lesser of (multiply by 2-3.5 OR add 80-400), plus random 30-60
			mana_charge = math.min(mana_charge * Randomf(2, 3.5), mana_charge + Random(80, 400))   + Random(30, 60)
			mana_charge = math.floor(math.min(mana_charge, 20000)) --max of 20k

			capacity = math.max(capacity - Random(1, 3) - math.floor(capacity*.1), 1) --remove 1-3 AND one more for every 10 slots it has
			-- (66 slot wand loses 7-9 slots lmao)

			ComponentSetValue2(ability_comp, "mana_max", mana_max)
			ComponentSetValue2(ability_comp, "mana_charge_speed", mana_charge)
			ComponentObjectSetValue2(ability_comp, "gun_config", "deck_capacity", capacity + always_cast_count)


			--nonsense to de-child overflowing spells from capacity decrease
			local c = EntityGetAllChildren(wand)
			if c and #c > capacity + always_cast_count then
				for i=always_cast_count+1,#c do
					local spell = c[i]
					local comp2 = EntityGetFirstComponentIncludingDisabled(spell, "ItemActionComponent")

					if comp2 and i > capacity + always_cast_count then

						EntityRemoveFromParent(spell)
						EntitySetTransform(spell, x, y, 0)

						--fixed tag stuff to properly enabled/disable correct tags (rather than just hard enable all components)
						for _,component in ipairs(EntityGetAllComponents(spell)) do
							if ComponentHasTag(component, "enabled_in_world") then
								EntitySetComponentIsEnabled(spell, component, true)
							else
								EntitySetComponentIsEnabled(spell, component, false)
							end
						end
					end
				end
			end
		end
	},
	["EDIT_WANDS_EVERYWHERE"] = { not_in_default_perk_pool = true },
	["LOW_RECOIL"] = {
		ui_name = "$hardmod_perk_no_recoil_name",
		ui_description = "$hardmod_perk_no_recoil_desc",
	},
	["ITEM_RADAR"] = {
		ui_icon = dir.."ui_gfx/perks/item_radar_016.png",
		perk_icon = dir.."ui_gfx/perks/item_radar.png",
	},
	["CONTACT_DAMAGE"] = {
		ui_icon = dir.."ui_gfx/perks/contact_damage_016.png",
		perk_icon = dir.."ui_gfx/perks/contact_damage.png",
		ui_description = "$hardmod_perk_contact_damage_desc",
		game_effect = "PROTECTION_MELEE",
	},
	--["LEVITATION_TRAIL"] = {
	--	func = function(perk_entity, entity_id, perk_name)
	--		EntityAddComponent2(entity_id, "LuaComponent", {
	--			_tags="perk_component",
	--			script_source_file = dir.."/levitation_trail/levitation_trail.lua",
	--			execute_every_n_frame = 3,
	--		})
	--	end
	--},
	["EXTRA_SHOP_ITEM"] = {
		ui_name = "$hardmod_perk_extra_shop_item_name",
		ui_description = "$hardmod_perk_extra_shop_item_desc",
		stackable_maximum = 10,
	},
	["LOWER_SPREAD"] = {
		ui_description = "$hardmod_perk_lower_spread_desc",
	},
}

--Perks recoverable via Kakkakikkare
local shit_perks = {
	"NO_WAND_EDITING",
	"REVENGE_RATS",
	"VOMIT_RATS",
	"CORDYCEPS",
	"MOLD",
	"FUNGAL_DISEASE",
	"LUKKI_MINION", --very ass
	"GLOBAL_GORE", --kinda ass
	"PERSONAL_LASER",
	"WORM_ATTRACTOR",
	"WORM_SMALLER_HOLES",
	"DUPLICATE_PROJECTILE",
	"MEGA_BEAM_STONE", --damn i like this one tho :(
	"LASER_AIM", -- replaced by Pinpointer spell
	"EXTRA_MANA", -- replaced by Summon Toolbox
	"EXTRA_SLOTS", -- replaced by Summon Toolbox
	"FASTER_WANDS", -- replaced by Summon Toolbox
	"FIRE_GAS", -- replaced by Pyromaniac
	"HOMUNCULUS",
	"TELEPORTITIS",
	"GOLD_IS_FOREVER",
	"ALWAYS_CAST",
}

--Perks removed for being too good or other various reasons
local remove_perks = {
	"EXTRA_MONEY", -- replaced by Treasure Hunter
	"PROJECTILE_REPULSION", --too strong, replaced by Oversized Shield (thank you Apotheosis)
	"GENOME_MORE_LOVE", --bad design: Oh boy, the perk that either does nothing, or makes less things happen! its either a scam or its boring, bad perk.
}

--bomb materialised, lukki mutation, no wand tinkering, more blood, personal plasma beam, low recoil, phasing, pinpointer, proj dupe, levitation trail, worm perks

for _,perk in ipairs(shit_perks) do
	hooks.perk_patches[perk] = { not_in_default_perk_pool = true, not_progress = true, hardmod_shit_perk = true }
end
for _,perk in ipairs(remove_perks) do
	hooks.perk_patches[perk] = { not_in_default_perk_pool = true, not_progress = true }
end

-- TODO: make these perks use a shot effect component instead of game_effect
-- CRITICAL_HIT_BOOST, GLASS_CANNON, LOW_HP_DAMAGE_BOOST(?), 


local spawn_inhibitor_spell = {
	PROJECTILE_HOMING = true,
	PROJECTILE_HOMING_SHOOTER = true,
	EXTRA_KNOCKBACK = true,
	LOWER_SPREAD = true,
	LOW_RECOIL = true,
	BOUNCE = true,
	FAST_PROJECTILES = true,
	DUPLICATE_PROJECTILE = true,
	LASER_AIM = true,
	FOOD_CLOCK = true,
}

hooks.edit_perk = function(perk)
	if spawn_inhibitor_spell[perk.id] then
		local orig_action = perk.func
		perk.func = function(item, ...)
			local x, y = EntityGetTransform(item)
			CreateItemActionEntity("HARDMOD_INHIBITOR", x, y)

			if orig_action then
				orig_action(item, ...)
			end
		end
	end
end

return hooks