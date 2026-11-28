--Useful functions.
---@class utils
local utils = {}

utils.module_dir = "mods/noita.hardmod/files/modules/"
utils.max_gold = 2147483647 --hardcoded value for infinite-money

-- de-patterning function for dealing with string.gsub() and other pattern-utilising Lua functions.
---@param str string
---@return string
---@return integer
function utils.escape(str) return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1") end

-- Same as utils.escape but for the replacement string (only escapes %)
function utils.escape_replacement(str) return str and str:gsub("%%", "%%%%") end

-- Convenient function to simplify modifying files. Any spaces/newlines in `from` are converted to `%s*`, so you don't have to worry about keeping original spaces.
---@param file string filepath
---@param from string target you wish to replace
---@param to string what you wish to replace it with
function utils.modifile(file, from, to)
	from = utils.escape(from):gsub("%s+", "%%s*")
	to = utils.escape_replacement(to)

	ModTextFileSetContent(file, ModTextFileGetContent(file):gsub(from, to))
end

---@class ModifileReplacement
---@field from string Search string. Any spaces/newlines are replaced with `%s*`, so you do not have to worry about keeping original spaces.
---@field to string? String to replace to (defaults to `from` if you use `insert_before`/`insert_after`)
---@field insert_before string? String to insert before the result
---@field insert_after string? String to insert after the result
---@field pattern boolean? Use `from` as a pattern instead of escaping it
---@field count integer? Amount of max replacements (e.g. 1 = only the first instance)

---More advanced version of `modifile`
---@param file string filepath
---@param replacements ModifileReplacement[] Array of replacements to apply to the file
function utils.patchifile(file, replacements)
	local content = ModTextFileGetContent(file)

	for _,replacement in pairs(replacements) do
		local from = replacement.pattern and replacement.from or utils.escape(replacement.from)
		local to = utils.escape_replacement(replacement.to or "")

		if not replacement.pattern then
			from = from:gsub("%s+", "%%s*")
		end

		if replacement.insert_before or replacement.insert_after then
			to = utils.escape_replacement(replacement.insert_before or "") .. "%1" .. utils.escape_replacement(replacement.insert_after or "")
			from = "("..from..")"
		elseif not replacement.to then
			error("Missing to or insert_before/insert_after in a replacement")
		end

		content = content:gsub(from, to, replacement.count)
	end

	ModTextFileSetContent(file, content)
end

---handy func i stole that converts an entire table to string, grabbed from [here](https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console)
---@param o table
---@return string
function utils.dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. utils.dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

---a version of the `dump()` function but with formatting
---@param o table
---@param q bool? should keys be in quotes
---@return string
function utils.dumpf(o, q, r)
	r = r or 0
	local _t = ('    '):rep(r)
	local t = type(o)
	if t == 'table' then
		local s = '{\n'
		local table_is_empty = true
		for k,v in pairs(o) do
			table_is_empty = false
			if type(k) == 'number' then
				k = '['..k..']'
			elseif q then
				k = '["'..k..'"]'
			end
			s = s .. _t .. '    '..k..' = ' .. utils.dumpf(v, q, r+1) .. ',\n'
		end
		if table_is_empty then
			return s:sub(1, -2) .. '}'
		else
			return s .. _t .. '}'
		end
	elseif t == "string" then
		return '"' .. tostring(o):gsub("\n", "\\n") .. '"'
	else
		return tostring(o)
	end
end



function utils.MatchDateLocal(check_date)
	local current = {}
	current.year, current.month, current.day, current.hour, current.minute, current.second, current.jussi, current.mammi = GameGetDateAndTimeLocal()
	for unit,value in pairs(check_date) do
		if current[unit] ~= value then return false end
	end
	return true
end


---@class (exact) Weighted
---@field weight number

---@class (exact) Seed
---@field [1] number
---@field [2] number

---@generic T : Weighted
---@param t T[]
---@return T
---Function for picking a random table entry on `weight` as weight
function utils.RandomFromTable(t)
	local total_weight = 0
	for _, entry in ipairs(t) do
		total_weight = total_weight + entry.weight
	end

	local rnd = Randomf(0, total_weight)
	for _, entry in ipairs(t) do
		if rnd <= entry.weight then
			return entry
		else rnd = rnd - entry.weight end
	end
	return t[#t]
end

---@generic T : Weighted
---@param t T[]
---@param context any This is passed into the condition function
---@param seed Seed|nil If a seed is passed, it will use `ProceduralRandomFromTable` instead of `RandomFromTable`.
---@return T|nil
---Compiles entries from `t` into a new table based on optional `condition` value in the entry and passes it through `RandomFromTable`. `context` is passed into the function as a parameter.
function utils.ConditionalRandomFromTable(t, context, seed)
	local temp = {}
	for _, entry in ipairs(t) do
		if entry.condition and not entry:condition(context) then goto continue end
		temp[#temp+1] = entry
		::continue::
	end

	if #temp == 0 then return end
	if seed then return utils.ProceduralRandomFromTable(temp, seed) else return utils.RandomFromTable(temp) end
end

---@generic T : Weighted
---@param t T[]
---@param seed Seed
---@return T
---Function for picking a procedurally random table entry on `weight` as weight based on `seed`
function utils.ProceduralRandomFromTable(t, seed)
	local total_weight = 0
	for _, entry in ipairs(t) do
		total_weight = total_weight + entry.weight
	end

	local rnd = ProceduralRandomf(seed[1], seed[2], 0, total_weight)
	for _, entry in ipairs(t) do
		if rnd <= entry.weight then
			return entry
		else rnd = rnd - entry.weight end
	end
	return t[#t] --Randomf has a miniscule chance to overflow
end


---simple func to get herd id, mostly for other funcs in this file to utilise
---@param entity_id entity_id
---@return int
function utils.GetHerdID(entity_id)
	local genome_comp = EntityGetFirstComponent(entity_id, "GenomeDataComponent")
	if genome_comp then return ComponentGetValue2(genome_comp, "herd_id")
	else return 0 end
end

---Replacement function for the vanilla `utilities.lua` function, `shoot_projectile()`.
---@param shooter entity_id?
---@param entity_file string filepath to projectile.xml
---@param x number
---@param y number
---@param vel_x number?
---@param vel_y number?
---@param send_message bool?
---@return entity_id
function utils.ShootProjectile(shooter, entity_file, x, y, vel_x, vel_y, send_message)
	---@type entity_id
	---@diagnostic disable-next-line: assign-type-mismatch
	shooter = shooter or 0
	local projectile = EntityLoad(entity_file, x, y)
	vel_x = vel_x or 0
	vel_y = vel_y or 0
	send_message =  send_message or true

	local herd_id = utils.GetHerdID(shooter)

	GameShootProjectile(shooter, x, y, x+vel_x, y+vel_y, projectile, send_message)

	local friendly_fire = EntityHasTag(shooter, "friendly_fire_enabled")
	if friendly_fire then EntityAddTag(projectile, "friendly_fire_enabled") end

	for _,proj_comp in ipairs(EntityGetComponent(projectile, "ProjectileComponent") or {}) do
		ComponentSetValue2(proj_comp, "mWhoShot", shooter)
		ComponentSetValue2(proj_comp, "mShooterHerdId", herd_id) --should be fine if nil..?

		if friendly_fire then
			ComponentSetValue2(proj_comp, "friendly_fire", true)
			ComponentSetValue2(proj_comp, "collide_with_shooter_frames", 6)
		end
	end

	for _,vel_comp in ipairs(EntityGetComponent(projectile, "VelocityComponent") or {}) do
		ComponentSetValue2(vel_comp, "mVelocity", vel_x, vel_y)
	end

	return projectile
end

---Shorthand for quickly getting the int value of a VSC
---@param entity_id entity_id ID of the entity
---@param variable_name string Name of the variable
---@param create_if_nil? boolean If true, a new VSC of the given name will be created if it doesn't exist
---@return int Value that matches the given VSC name
function utils.GetInternalInt(entity_id, variable_name, create_if_nil)
	local value = nil
	local vscomps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
	if vscomps ~= nil then
		for key,comp_id in pairs(vscomps) do
			local var_name = ComponentGetValue2(comp_id, "name")
			if var_name == variable_name then
				value = ComponentGetValue2(comp_id, "value_int")
			end
		end
	end

	if value == nil and create_if_nil then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = variable_name,
			value_int = 0
		})
		value = 0
	end

	return value
end

---Shorthand for quickly setting a VSC's int value, or creating one if a VSC with the same name doesn't exist yet
---@param entity_id entity_id ID of the entity
---@param variable_name string Name of the variable
---@param new_value int New value of the variable (or initial value, if VSC did not exist)
---@return int new_value Returns the given value for convenience
function utils.SetInternalInt(entity_id, variable_name, new_value)
	local variable_found = false
	local vscomps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
	if vscomps ~= nil then
		for key,comp_id in pairs(vscomps) do
			local var_name = ComponentGetValue2(comp_id, "name")
			if var_name == variable_name then
				ComponentSetValue2(comp_id, "value_int", new_value)
				variable_found = true
			end
		end
	end

	if not variable_found then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = variable_name,
			value_int = new_value
		})
	end

	return new_value
end

---Shorthand for quickly getting the string value of a VSC
---@param entity_id entity_id ID of the entity
---@param variable_name string Name of the variable
---@param create_if_nil? boolean If true, a new VSC of the given name will be created if it doesn't exist
---@return string Value that matches the given VSC name
function utils.GetInternalString(entity_id, variable_name, create_if_nil)
	local value = nil
	local vscomps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
	if vscomps ~= nil then
		for key,comp_id in pairs(vscomps) do
			local var_name = ComponentGetValue2(comp_id, "name")
			if var_name == variable_name then
				value = ComponentGetValue2(comp_id, "value_string")
			end
		end
	end

	if value == nil and create_if_nil then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = variable_name,
			value_string = ""
		})
		value = ""
	end

	return value
end

---Shorthand for quickly setting a VSC's string value, or creating one if a VSC with the same name doesn't exist yet
---@param entity_id entity_id ID of the entity
---@param variable_name string Name of the variable
---@param new_value string New value of the variable (or initial value, if VSC did not exist)
function utils.SetInternalString(entity_id, variable_name, new_value)
	local variable_found = false
	local vscomps = EntityGetComponent(entity_id, "VariableStorageComponent")
	if vscomps ~= nil then
		for key,comp_id in pairs(vscomps) do
			local var_name = ComponentGetValue2(comp_id, "name")
			if var_name == variable_name then
				ComponentSetValue2(comp_id, "value_string", new_value)
				variable_found = true
			end
		end
	end

	if not variable_found then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = variable_name,
			value_string = new_value
		})
	end
end

---Shorthand for quickly getting the bool value of a VSC
---@param entity_id entity_id ID of the entity
---@param variable_name string Name of the variable
---@return bool Value that matches the given VSC name
function utils.GetInternalBool(entity_id, variable_name)
	local value = nil
	local vscomps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
	if vscomps ~= nil then
		for key,comp_id in pairs(vscomps) do
			local var_name = ComponentGetValue2(comp_id, "name")
			if var_name == variable_name then
				value = ComponentGetValue2(comp_id, "value_bool")
			end
		end
	end

	return value
end

---Shorthand for quickly setting a VSC's bool value, or creating one if a VSC with the same name doesn't exist yet
---@param entity_id entity_id ID of the entity
---@param variable_name string Name of the variable
---@param new_value bool New value of the variable (or initial value, if VSC did not exist)
function utils.SetInternalBool(entity_id, variable_name, new_value)
	local variable_found = false
	local vscomps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
	if vscomps ~= nil then
		for key,comp_id in pairs(vscomps) do
			local var_name = ComponentGetValue2(comp_id, "name")
			if var_name == variable_name then
				ComponentSetValue2(comp_id, "value_bool", new_value)
				variable_found = true
			end
		end
	end

	if not variable_found then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = variable_name,
			value_bool  = new_value
		})
	end
end

---@param eid entity_id
---@param var_name string
---@return entity_id?
function utils.GetInternalEntityId(eid, var_name)
	---@diagnostic disable-next-line: return-type-mismatch
	return utils.GetInternalInt(eid, var_name)
end

---@param eid entity_id
---@param var_name string
---@param value entity_id
function utils.SetInternalEntityId(eid, var_name, value)
	---@diagnostic disable-next-line: param-type-mismatch
	utils.SetInternalInt(eid, var_name, value)
end

---Returns the player, polymorphed or not. Pass x, y and distance for a distance check.
---@param x number?
---@param y number?
---@param distance number?
---@returns entity_id?
function utils.GetPlayerEntity(x, y, distance)
	local tags = {"player_unit", "polymorphed_player", "polymorphed_cessation"}
	for _,tag in pairs(tags) do
		local player

		if x and y and distance then
			player = EntityGetInRadiusWithTag(x, y, distance, tag)
		else
			player = EntityGetWithTag(tag)
		end

		if #player > 0 then
			return player[1]
		end
	end

	return nil
end

---Remaps a value between (a1,b1) to (a2,b2)
---@param value int Value to remap
---@param inMin int Lower end of the input range
---@param inMax int Higher end of the input range
---@param outMin int Lower end of the output range
---@param outMax int Higher end of the output range
---@return int result The mapped value
function utils.Remap(value, inMin, inMax, outMin, outMax)
	if inMax == inMin then
		error("Input range cannot have zero length")
	end

	-- normalise the input value to a 0‑1 scale
	local t = (value - inMin) / (inMax - inMin)

	return outMin + t * (outMax - outMin)
end

--- Returns the pickup count of a specific perk
---@param perk_id string The perk's ID, i.e. "REMOVE_FOG_OF_WAR"
---@return number count The amount of times this perk was taken by the player.
function utils.GetPerkPickupCount(perk_id)
	dofile_once("data/scripts/perks/perk_list.lua")

	local flag_name = get_perk_picked_flag_name(perk_id)
	local pickup_count = tonumber(GlobalsGetValue(flag_name .. "_PICKUP_COUNT", "0"))

	return pickup_count or 0
end

--- Triggers a lua script after a delay
---@param entity_id entity_id The entity that will hold the LuaComponent
---@param script_path string Path to the script to be executed
---@param delay int? Delay before script execution in frames (default 30)
function utils.TriggerScriptDelayed(entity_id, script_path, delay)
	delay = delay or 30
	EntityAddComponent2(entity_id, "LuaComponent", {
		script_source_file = script_path,
		execute_on_added = false,
		execute_every_n_frame = delay,
		remove_after_executed = true,
	})
end

--- Shorthand for removing all children and components that match a given tag
---@param entity_id entity_id The entity id of the entity whose children and components are to be removed
---@param tag string The tag to filter by
function utils.EntityRemoveAllByTag(entity_id, tag)
	for i,child_id in ipairs(EntityGetAllChildren(entity_id, tag) or {}) do
		if EntityHasTag(child_id, tag) then
			EntityKill(child_id)
		end
	end
	for i,comp_id in ipairs(EntityGetAllComponents(entity_id)) do
		if ComponentHasTag(comp_id, tag) then
			EntityRemoveComponent(entity_id, comp_id)
		end
	end
end

---Formats an integer as an ordinal (1st, 2nd, 3rd, 4th, etc).
---English-only, currently used only for splashes which aren't translated
---@param int integer
---@return string
function utils.EnglishOrd(int)
	local frac = int % 10
	if frac == 1 then return int.."st" end
	if frac == 2 then return int.."nd" end
	if frac == 3 then return int.."rd" end
	return int.."th"
end

---Changes an entity's HP/max HP in DamageModelComponent. Values are 1/25
---@param eid entity_id Entity's ID
---@param hp integer? New HP (if nil and max_hp is present, will keep the entity's old HP but cap it)
---@param max_hp integer? New max HP (omit to not change it)
function utils.EntitySetHp(eid, hp, max_hp)
	local dmc = EntityGetFirstComponent(eid, "DamageModelComponent")
	if not dmc then return end

	if not hp and max_hp then
		hp = math.min(tonumber(ComponentGetValue2(dmc, "hp")) or max_hp, max_hp)
	end

	if max_hp then ComponentSetValue2(dmc, "max_hp", max_hp) end
	if hp then ComponentSetValue2(dmc, "hp", hp) end
end

---Returns an entity's HP and max HP from DamageModelComponent
---@param eid entity_id Entity's ID
---@return { hp: integer, max_hp: int }? hp Entity's health; values are 1/25
function utils.EntityGetHp(eid)
	local dmc = EntityGetFirstComponent(eid, "DamageModelComponent")
	if not dmc then return end
	return {
		hp = tonumber(ComponentGetValue2(dmc, "hp")),
		max_hp = tonumber(ComponentGetValue2(dmc, "max_hp")),
	}
end

---Adds `increment` to the entity's HP in DamageModelComponent
---@param eid entity_id Entity's ID
---@param increment integer Value to add (pass negative to reduce HP instead); value is 1/25
function utils.EntityAddHp(eid, increment)
	local hp = utils.EntityGetHp(eid)
	if not hp then return end
	utils.EntitySetHp(eid, hp.hp + increment)
end

---Add an enemy `enemy` to the progress list after `after_enemy`.
---The enemy must be defined in `data/ui_gfx/animal_icons` and `data/entities/animals` (see existing enemies).
---This function simply changes the order of the custom enemy.
---
---Must be called during mod init.
function utils.AddEnemyToProgress(enemy, after_existing_enemy)
	utils.patchifile("data/ui_gfx/animal_icons/_list.txt", {
		{
			from = after_existing_enemy .. "\n",
			insert_after = enemy .. "\n",
			count = 1
		}
	})
end

---Calculates the X offest of a SpriteComponent for a price using nolla's formula
---@param cost_int integer
---@return integer width
function utils.GetIntegerCostOffsetX(cost_int)
	local str = tostring(cost_int)
	local width = 0

	for i=1,#str do
		if str[i] == "1" then
			width = width + 3
		else
			width = width + 6
		end
	end

	return width * 0.5 - 0.5
end

---Clones a table
---@param orig table
---@param copies nil
---@return table
function utils.deepcopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[utils.deepcopy(orig_key, copies)] = utils.deepcopy(orig_value, copies)
			end
			setmetatable(copy, utils.deepcopy(getmetatable(orig), copies))
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end


---Get held wand or first wand found in the entity tree or nil
---@param entity_id entity_id
---@return entity_id|nil
function utils.GetHeldWand(entity_id)
	local backup_result

	local inventory2_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "Inventory2Component")
	if inventory2_comp ~= nil then
		local active_item = ComponentGetValue2(inventory2_comp, "mActualActiveItem")
		if EntityHasTag(active_item, "wand") then
			return active_item
		end
	end

	-- if that doesn't work (e.g. player is holding something else than a wand)
	for _,child in ipairs(EntityGetAllChildren(entity_id) or {}) do
		if EntityHasTag(child, "wand") and EntityGetFirstComponent(child, "ItemComponent") then
			return child
		else
			backup_result = utils.GetHeldWand(child)
		end
	end

	return backup_result
end

function utils.WandAddAlwaysCast(entity_id, action_id)
	local action_entity_id = CreateItemActionEntity(action_id)
	EntityAddChild(entity_id, action_entity_id)

	-- we need to add a slot to the ability_comp
	local ability_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "AbilityComponent")
	if ability_comp then
		local deck_capacity = ComponentObjectGetValue2(ability_comp, "gun_config", "deck_capacity")
		deck_capacity = deck_capacity + 1
		ComponentObjectSetValue2(ability_comp, "gun_config", "deck_capacity", deck_capacity)
	end

	local item_component = EntityGetFirstComponentIncludingDisabled(action_entity_id, "ItemComponent")
	if item_component then
		ComponentSetValue2(item_component, "permanently_attached", true)
	end

	EntitySetComponentsWithTagEnabled(action_entity_id, "enabled_in_world", false)
end

---Spawns an emerald tablet at x,y with the specified title and description.
---This uses vanilla's book_00.xml as a base.
---@param x number
---@param y number
---@param title string
---@param desc string
function utils.SpawnTablet(x, y, title, desc)
	local book = EntityLoad("data/entities/items/books/book_00.xml", x, y)

	local itemcomp = EntityGetFirstComponent(book, "ItemComponent")
	if itemcomp then
		ComponentSetValue2(itemcomp, "item_name", title)
		ComponentSetValue2(itemcomp, "ui_description", desc)
	end

	local uiinfo = EntityGetFirstComponent(book, "UIInfoComponent")
	if uiinfo then ComponentSetValue2(uiinfo, "name", title) end

	local abilitycomp = EntityGetFirstComponent(book, "AbilityComponent")
	if abilitycomp then ComponentSetValue2(abilitycomp, "ui_name", title) end
end

--TOFINISH
function utils.LinebreakString(str, max_width, font)
	local current_line = ""
	local lines = {}
	for word in str:gmatch("%S+") do
		local test_line = (current_line == "") and word or current_line .. " " .. word
		local test_line_w = GuiGetTextDimensions(gui, test_line, 1, 2, font)
		if test_line_w > max_width then
			lines[#lines + 1] = current_line
			current_line = word
		else
			if test_line_w > max_width then max_width = test_line_w end
			current_line = test_line
		end
	end

	return table.concat(lines, "\n")
end

---Function to spawn perks in a circle formation
---@param perks table list of perks
---@param x any
---@param y any
---@param radius any
---@return table
function utils.SpawnPerkCircle(perks, x, y, radius)
	radius = radius or 0
	local radian = 2*math.pi
	radius = math.max(radius, #perks*20/(radian))

	local step = 1/#perks
	local random_rot = Randomf(0, step)
	local perk_eids = {}
	for i,perk in ipairs(perks) do
		local perk_id =  type(perk) == "table" and perk.id or perk
		local x_pos = x + radius * math.cos((i * step * radian)+random_rot)
		local y_pos = y + radius * math.sin((i * step * radian)+random_rot)
		perk_eids[#perk_eids+1] = perk_spawn(x_pos, y_pos, perk_id, true)
	end

	return perk_eids
end

--- Function to find a child entity based on their entity name
---@param entity_id entity_id Entity ID of the parent
---@param name string Name of the child to look for
---@return entity_id? Entity ID of the first match, or nil if none was found
function utils.EntityGetChildByName(entity_id, name)
	local children = EntityGetAllChildren(entity_id) or {}
	for _,child in ipairs(children) do
		if EntityGetName(child) == name then
			return child
		end
	end
	return nil
end

--- Replaces vanilla utilities' random_from_array function
---@param array table Array to get a random element from
---@param seed_a int? Seed value a (defaults to GameGetFrameNum() if nil)
---@param seed_b int? Seed value b (defaults to GameGetFrameNum() if nil)
---@return int A random element from the array
function utils.RandomFromArray(array, seed_a, seed_b)
	seed_a = seed_a or GameGetFrameNum()
	seed_b = seed_b or GameGetFrameNum()
	SetRandomSeed(seed_a, seed_b)
	return array[Random(1, #array)]
end

local _spell_index = nil
--- Gets a spell with a specified `id`, using an indexed table.
--- 
--- Note: Ensure you're importing utilities.lua via `dofile_once`!!!
--- @param id string
--- @return GunAction?
function utils.GetSpell(id)
	if not actions then
		dofile_once("data/scripts/gun/gun_actions.lua")
	end

	if not _spell_index then
		_spell_index = {}
		for _,spell in pairs(actions) do
			_spell_index[spell.id] = spell
		end
	end

	return _spell_index[id]
end

--- Returns the position of the tip of the wand held by `shooter`
---@param shooter entity_id
---@return number x, number y, number rotation, boolean found
function utils.GetWandTipPos(shooter)
	local x, y, rot = EntityGetTransform(shooter)
	local wx, wy, wr = x, y, rot
	local found = false
	local inventory = EntityGetFirstComponent(shooter, "Inventory2Component")
	if inventory then
		local active_wand = ComponentGetValue2(inventory, "mActiveItem")
		if EntityHasTag(active_wand, "wand") then
			local _, _, wand_rot = EntityGetTransform(active_wand)
			local comp = EntityGetFirstComponentIncludingDisabled(active_wand, "HotspotComponent", "shoot_pos")
			if comp then
				local ox, oy = ComponentGetValue2(comp, "offset")
				local tx = math.cos(wand_rot) * ox - math.sin(wand_rot) * oy
				local ty = math.sin(wand_rot) * ox + math.cos(wand_rot) * oy
				wx, wy = wx + tx, wy + ty - 4
				wr = wand_rot
				found = true
			end
		end
	end

	return wx, wy, wr, found
end

local _rand_y = 0
--- Changes the current PRNG seed (`SetRandomSeed`) with the current frame *and* an increment,
--- allowing you to use it multiple times in a single frame
function utils.RandomizeSeed()
	SetRandomSeed(GameGetFrameNum(), _rand_y)
	_rand_y = _rand_y + 1
end

utils.logging = false
---useful logger than can be enabled/disabled at will
---@param ... any all parameters are concatenated into one string
function utils.log(...)
	if utils.logging then
		local t = {...}
		for i,v in ipairs(t) do t[i] = tostring(v) end
		print(table.concat(t))
	end
end

---get distance between two points
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function utils.get_distance(x1, y1, x2, y2)
	return ((x2-x1)^2 + (y2-y1)^2)^.5
end

---@param entity_id entity_id
---@return table
function utils.EntityGetMaterialsThatDamage(entity_id)
	local dmc = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
	if not dmc then return {} end --maybe return nil here? will change based on what seems most convenient

	local materials_that_damage = {}

	local mats = ComponentGetValue2(dmc, "materials_that_damage"):gmatch("[^,]+")
	local dmgs = ComponentGetValue2(dmc, "materials_how_much_damage"):gmatch("[^,]+")

	for mat in mats do
		local damage = dmgs()
		if not damage then break end

		table.insert(materials_that_damage, {
			material = mat,
			damage = tonumber(damage) or 0
		})
	end

	return materials_that_damage
end


---Shuffles a table randomly
---@param t table
---@return table
function utils.ShuffleTable(t)
	for i = #t, 2, -1 do
		local j = Random(1, i)
		t[i], t[j] = t[j], t[i]
	end
	return t
end



function utils.IsPlayer(entity_id)
	return EntityHasTag(entity_id, "player_unit") or EntityHasTag(entity_id, "polymorphed_player")
end

return utils