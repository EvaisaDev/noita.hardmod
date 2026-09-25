--Useful scripts.


---handy func i stole that converts an entire table to string, grabbed from [here](https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console)
---@param o table
---@return string
---@diagnostic disable-next-line: lowercase-global
function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
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
---@diagnostic disable-next-line: lowercase-global
function dumpf(o, q, r)
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
			s = s .. _t .. '    '..k..' = ' .. dumpf(v,q,r+1) .. ',\n'
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



function MatchDateLocal(check_date)
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
function RandomFromTable(t)
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
function ConditionalRandomFromTable(t, context, seed)
	local temp = {}
	for _, entry in ipairs(t) do
		if entry.condition and not entry:condition(context) then goto continue end
		temp[#temp+1] = entry
		::continue::
	end

	if #temp == 0 then return end
	if seed then return ProceduralRandomFromTable(temp, seed) else return RandomFromTable(temp) end
end

---@generic T : Weighted
---@param t T[]
---@param seed Seed
---@return T
---Function for picking a procedurally random table entry on `weight` as weight based on `seed`
function ProceduralRandomFromTable(t, seed)
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
function GetHerdID(entity_id)
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
function ShootProjectile(shooter, entity_file, x, y, vel_x, vel_y, send_message)
	---@type entity_id
	shooter = shooter or 0
	local entity_id = EntityLoad(entity_file, x, y)
	vel_x = vel_x or 0
	vel_y = vel_y or 0
	send_message =  send_message or true

	local herd_id = GetHerdID(shooter)

	GameShootProjectile(shooter, x, y, x+vel_x, y+vel_y, entity_id, send_message)

	for _, proj_comp in ipairs(EntityGetComponent(entity_id, "ProjectileComponent") or {}) do
		ComponentSetValue2(proj_comp, "mWhoShot", shooter)
		ComponentSetValue2(proj_comp, "mShooterHerdId", herd_id) --should be fine if nil..?
	end

	for _, vel_comp in ipairs(EntityGetComponent(entity_id, "VelocityComponent") or {}) do
		ComponentSetValue2(vel_comp, "mVelocity", vel_x, vel_y)
	end

	return entity_id
end