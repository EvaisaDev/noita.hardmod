local utilities = {} ---@class eperk_utils
local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils
local enemy_perks
local enemy_perks_indexed = {}

---@class enemy_perk
---@field id string string ID
---@field name string? string name (viewable in progress)
---@field description string? description of the perk (viewable in progress)
---@field sprite string? path to the perk's sprite
---@field icon string? path to the perk's icon
---@field not_progress boolean? if true, perk won't show up in progress menu
---@field priority number? priority for the order its shown above enemies' heads or in the inspect window, default 10
---@field weight number? probability of the perk being pulled, default 10
---@field level_add_weight number? this value multiplied by current level is added to the weight, bound to `level_add_weight_min` and `level_add_weight_max`
---@field level_add_weight_min number? this value acts as the  bound for `level_add_weight`, default is .1x the base weight
---@field level_add_weight_max number? this value acts as the  bound for `level_add_weight`, default is 10x the base weight
---@field stack_multiplier number? the multiplier applied to the perk weight for each stack already held, default 1.15
---@field min_level number? the lower level limit for this perk to be selected
---@field max_level number? the upper level limit for this perk to be selected
---@field unique_slot string? if set, will disallow other enemy perks with the same unique_slot value to be selected
---@field not_boss bool? blacklists bosses from gaining this perk
---@field not_shop_guardian bool? blacklists stevari and skoude from gaining this perk
---@field requires_dmc boolean? what it says on the tin
---@field requires_animal_ai_component boolean? what it says on the tin, if nil then will double check for other animalaicomp-related requirements
---@field max integer? max number of this perk an enemy can have
---@field requires_animal_ranged_ability true|boolean?
---@field biome_conditions table? custom condition functions that run if the target_enemy is in the keyed biome, if value is a number it will set the perk weight to that value
---@field condition function? if added, this function must return true, is passed the `data` table
---@field func function? function that actually does the stuff, is passed the `data` table
---@field func_handler function? function that runs on the perk handler every 80f, is passed sprite components of in-world perk icons
---@field func_inspector function? function that runs every frame in the eperk inspector, is passed a table of all the perks held by the enemy
---@field post_func function? function that runs after all perks have been applied

utilities.biome_levels = {
	default_biome_data = {
		level = 3,
		do_recursive_roll = true,
		--range = {0, 0},
		--custom_func = function(self, entity_id) end --return perk num
	},
	mines = 1, --mines
	collapsed_mines = 2,
	coal_pits = 2, --coal pits
	fungal_caverns = 3, --fungal caverns
	snowy_depths = 3, --snowy depths
	magical_temple = 4, --snowy depths
	hiisi_base = 4, --hiisi base
	jungle = 5, --jungle
	lukki_lair = 6, --lukki lair
	vault = 6,
	temple_of_the_art = 7,

	ancient_lab = 4,
	surface_desert = 7,
	surface_snowy = 7,
	wizards_den = 8,
	sandcave = 8,
	wandmart = 8,
	powerplant = {
		level = 6,
		range = {1, 2} --guaranteed 1-2 perks base
	},
	meat_realm = 9,
	sky = 12,
	hell = 12,

	holy_mountain = {
		level = 0,
		custom_func = function(self, entity_id, x, y)
			local levels = {
				2,
				5,
				9,
				12,
				16,
				20,
				25,
			}

			local y_chunk_level = math.floor(y/512)
			local num = 0
			for i,stage_boundary in ipairs(levels) do
				if stage_boundary > y_chunk_level then break end
				num = i
			end

			return num
		end
	}
}

for biome,data in pairs(utilities.biome_levels) do
	if type(data) == "number" then
		utilities.biome_levels[biome] = {
			level = data
		}
	end
end

function utilities.select_random_perk(t, data)
	t = utils.deepcopy(t)
	local level = data.level

	local temp = {}
	for _, entry in ipairs(t) do
		local id = entry.id
		local max, min_level, max_level = entry.max, entry.min_level, entry.max_level

		if entry.requires_dmc and not data.dmc then goto continue end
		if entry.requires_animal_ai_component and not data.animal_ai_comp then goto continue end
		if entry.requires_animal_ranged_ability then
			if not data.animal_ranged_ability then goto continue
			elseif type(entry.requires_animal_ranged_ability) == "string"
				and entry.requires_animal_ranged_ability ~= data.animal_ranged_ability then goto continue
			end
		end

		if data.is_boss and entry.not_boss then goto continue end
		if data.is_shop_guardian and entry.not_shop_guardian then goto continue end
		local unique_slot = entry.unique_slot
		if unique_slot then
			local taken_by = data.unique_slots[unique_slot]
			if taken_by ~= nil and taken_by ~= id then goto continue end
		end
		if max and max <= (data.how_many_of_each_perk[id] or 0) then goto continue end
		if (min_level and min_level > level) or (max_level and level > max_level) then goto continue end
		if entry.entity_blacklist and entry.entity_blacklist[data.filename] then goto continue end

		if entry.condition and not entry:condition(data) then goto continue end


		if data.level_add_weight then
			data.weight = math.max(data.level_add_weight_min, math.min(data.level_add_weight_max, data.weight + data.level_add_weight * data.level))
		end
		if data.how_many_of_each_perk[id] then entry.weight = entry.weight * entry.stack_multiplier^data.how_many_of_each_perk[id] end

		temp[#temp+1] = entry
		::continue::
	end

	if #temp == 0 then return end

	return utils.RandomFromTable(temp)
end

---function to give enemy perks
---@param entity_id entity_id
---@param perks_to_give table|int|nil pass number to pass X random perks, pass table to give specific selection of perks
---@param data table context passed to functions, used for both random selection and perk behaviour
function utilities.give_enemy_perks(entity_id, perks_to_give, data)
	local perks_to_give_type = type(perks_to_give)
	local amount_of_perks = perks_to_give_type == "number" and perks_to_give
		or perks_to_give_type == "table" and #perks_to_give
		or 1

	if amount_of_perks == 0 then return end

	-- do not give perks to entities who drop no gold
	for _,vsc_comp in ipairs(EntityGetComponent(entity_id, "VariableStorageComponent") or {}) do
		if ComponentHasTag(vsc_comp, "no_gold_drop") then return end
	end

	local x, y = EntityGetTransform(entity_id)
	local enemy_perks_handler
	for _,child in ipairs(EntityGetAllChildren(entity_id) or {}) do
		if EntityGetName(child) == "hardmod.enemy_perks" then enemy_perks_handler = child break end
	end
	if not enemy_perks_handler then
		enemy_perks_handler = EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/handler.xml", x, y)
		EntityAddChild(entity_id, enemy_perks_handler)
	end
	data.handler = enemy_perks_handler

	local has_death_handler
	for _,luacomp in ipairs(EntityGetComponent(entity_id, "LuaComponent") or {}) do
		if ComponentGetValue2(luacomp, "script_death") == "mods/noita.hardmod/files/modules/enemy_perks/perk_holder_died.lua" then has_death_handler = true break end
	end
	if not has_death_handler then
		EntityAddComponent2(entity_id, "LuaComponent", {
			script_death = "mods/noita.hardmod/files/modules/enemy_perks/perk_holder_died.lua"
		})
	end

	local already_held_perks = {}
	local how_many_of_each_perk = {}
	local enemy_perk_data
	for _,varcomp in ipairs(EntityGetComponent(enemy_perks_handler, "VariableStorageComponent") or {}) do
		if ComponentGetValue2(varcomp, "name") == "enemy_perk_data" then enemy_perk_data = varcomp break end
	end
	if not enemy_perk_data then
		enemy_perk_data = EntityAddComponent2(enemy_perks_handler, "VariableStorageComponent", {name = "enemy_perk_data"})
	else
		for perk_id in ComponentGetValue2(enemy_perk_data, "value_string"):gmatch("([^,]+)") do
			already_held_perks[#already_held_perks+1] = perk_id
			how_many_of_each_perk[perk_id] = (how_many_of_each_perk[perk_id] or 0) + 1
		end
	end

	local a,b,c,d,e,f,g,h = GameGetDateAndTimeLocal()
	data.time_local = {
		year = a,
		month = b,
		day = c,
		hour = d,
		minute = e,
		second = f,
		jussi = g,
		mammi = h,
	}

	data.unique_slots = {}
	data.already_held_perks = already_held_perks
	data.how_many_of_each_perk = how_many_of_each_perk

	data.filename = EntityGetFilename(entity_id)
	data.dmc = EntityGetFirstComponent(entity_id, "DamageModelComponent")
	data.animal_ai_comp = EntityGetFirstComponent(entity_id, "AnimalAIComponent")
	if data.animal_ai_comp then
		if ComponentGetValue2(data.animal_ai_comp, "attack_ranged_enabled") then
			local summoners = {
				["data/entities/animals/bigbat.xml"] = true,
				["data/entities/animals/giant.xml"] = true,
			}

			if summoners[data.filename] then
				data.animal_ranged_ability = "summon"
			elseif ComponentGetValue2(data.animal_ai_comp, "tries_to_ranged_attack_friends") then
				data.animal_ranged_ability = "support"
			else
				data.animal_ranged_ability = "attack"
			end
			data.animal_ranged_cooldown = ComponentGetValue2(data.animal_ai_comp, "attack_ranged_frames_between")
		end

		data.animal_has_melee_attack = ComponentGetValue2(data.animal_ai_comp, "attack_melee_enabled")
		data.animal_has_dash_attack = ComponentGetValue2(data.animal_ai_comp, "attack_dash_enabled")
	end
	data.is_polymorphed = GameGetGameEffectCount(entity_id, "POLYMORPH")
		+ GameGetGameEffectCount(entity_id, "POLYMORPH_RANDOM")
		+ GameGetGameEffectCount(entity_id, "POLYMORPH_UNSTABLE") ~= 0

	local selected_perks = {}
	data.selected_perks = selected_perks --idk maybe someone can do some bullshit with this lmao
	if perks_to_give_type == "number" then
		data.perks_to_give = perks_to_give
		while data.perks_to_give > 0 do
			local perk = utilities.select_random_perk(enemy_perks, data)
			if not perk then return end
			perk:func(entity_id, data)
			selected_perks[#selected_perks+1] = perk
			already_held_perks[#already_held_perks+1] = perk.id
			how_many_of_each_perk[perk.id] = (how_many_of_each_perk[perk.id] or 0) + 1
			if perk.unique_slot then data.unique_slots[perk.unique_slot] = perk.id end

			data.perks_to_give = data.perks_to_give - 1
		end
	elseif perks_to_give_type == "table" then
		for _,perk in ipairs(perks_to_give) do
			if type(perk) == "string" then
				perk = enemy_perks_indexed[perk]
			end
			perk:func(entity_id, data)
			selected_perks[#selected_perks+1] = perk
			already_held_perks[#already_held_perks+1] = perk.id
			how_many_of_each_perk[perk.id] = (how_many_of_each_perk[perk.id] or 0) + 1
		end
	end


	ComponentSetValue2(enemy_perk_data, "value_string", table.concat(already_held_perks, ","))
	ComponentSetValue2(enemy_perk_data, "value_int", #already_held_perks)

	if not EntityHasTag(entity_id, "hardmod_blessed") then
		EntityAddTag(entity_id, "hardmod_blessed")
	end

	for _,perk in ipairs(selected_perks) do
		if perk.post_func then perk:post_func(entity_id, data) end
	end
end


function utilities.handle_perk_on_death(perks, ddata)
	ddata.attacker_was_player = EntityHasTag(ddata.attacker, "player_unit") or EntityHasTag(ddata.attacker, "polymorphed_player")

	local new_perk_discovered
	ddata.held_perks = {}
	ddata.how_many_of_each_perk = {}
	for perk_id in perks:gmatch("([^,]+)") do
		ddata.how_many_of_each_perk[perk_id] = (perk_id[perk_id] or 0) + 1
		ddata.held_perks[#ddata.held_perks+1] = perk_id
		if ddata.attacker_was_player then
			local persistent_flag_name = "perk_picked_enemyperk_"..perk_id:lower()
			if not HasFlagPersistent(persistent_flag_name) then
				new_perk_discovered = true
				AddFlagPersistent(persistent_flag_name)
				GameAddFlagRun("new_"..persistent_flag_name)
			end
		end
	end
	if new_perk_discovered then GameAddFlagRun("hardmod_new_enemy_perk_discovered") end

	local x,y = EntityGetTransform(ddata.entity_id)
	SetRandomSeed(5932+y, x-135)
	for _,perk in ipairs(dofile_once("mods/noita.hardmod/files/modules/enemy_perks/enemy_perks_list.lua")) do
		if perk.on_death and ddata.how_many_of_each_perk[perk.id] then
			for _=1,ddata.how_many_of_each_perk[perk.id] do
				perk:on_death(ddata.entity_identity_id, ddata)
			end
		end
	end
end


return function(eperks)
	enemy_perks = eperks
	for _,perk in ipairs(enemy_perks) do
		enemy_perks_indexed[perk.id] = perk
	end
	return utilities
end
