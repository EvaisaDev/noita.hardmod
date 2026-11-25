local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local MAX_LINKED_RADIUS = 300

local owner = EntityGetRootEntity( GetUpdatedEntityID() )
local x, y = EntityGetTransform( owner )
local ally = utils.GetInternalInt( owner, "hardmod_soul_linked_ally" ) or 0

local function seek_new_ally()
	-- check if the ally is not dying within 5 frames
	if (utils.GetInternalInt(owner, "hardmod_soul_linked_death") or 0) == 1 then return end

	-- find an enemy to soul link with
	local nearby_enemies = EntityGetInRadiusWithTag( x, y, 150, "enemy" )
	if not nearby_enemies or #nearby_enemies == 0 then return end
	local candidates = {}
	for _,nearby_enemy in ipairs( nearby_enemies ) do
		-- if the enemy already has perks of its own (i.e. Ira cannot have a soul link)...
		if EntityHasTag( nearby_enemy, "hardmod_blessed" )
		-- and if the owner can tolerate that enemy...
		and ( nearby_enemy ~= owner and EntityGetHerdRelationSafe( owner, nearby_enemy ) >= 80 )
		-- and the target is not yet soul linked to another...
		and ( utils.GetInternalInt( nearby_enemy, "hardmod_soul_linked_ally" ) or 0 ) == 0 then
		--- ...add them as a candidate
			table.insert( candidates, nearby_enemy )
		end
	end
	if not candidates or #candidates == 0 then return end
	ally = utils.RandomFromArray(candidates, x, y)

	-- give the enemy's new soul linked ally the perk, too - but only visually
	-- eperk_utils.give_enemy_perks(ally, "SOUL_LINKED", data)

	-- give both enemies the entity id of its ally, so the script can check for their hp
	utils.SetInternalInt( ally, "hardmod_soul_linked_ally", owner )
	utils.SetInternalInt( owner, "hardmod_soul_linked_ally", ally )

	-- give both enemies a script that tries to prevent their death
	EntityAddComponent2( owner, "LuaComponent", {
		script_damage_received = "mods/noita.hardmod/files/modules/enemy_perks/scripts/soul_linked_on_damage.lua",
		script_death = "mods/noita.hardmod/files/modules/enemy_perks/scripts/soul_linked_on_damage.lua",
		execute_every_n_frame = -1,
	})
	EntityAddComponent2( ally, "LuaComponent", {
		script_damage_received = "mods/noita.hardmod/files/modules/enemy_perks/scripts/soul_linked_on_damage.lua",
		script_death = "mods/noita.hardmod/files/modules/enemy_perks/scripts/soul_linked_on_damage.lua",
		execute_every_n_frame = -1,
	})

	-- give the ally the vfx entity, to draw a particle line
	EntityAddChild( ally, EntityLoad( "mods/noita.hardmod/files/modules/enemy_perks/entities/soul_linked_vfx.xml", x, y ) )

	-- enable the owner's particles
	for _,child in ipairs(EntityGetAllChildren(owner, "hardmod_soul_linked") or {}) do
        EntitySetComponentsWithTagEnabled(child, "hardmod_soul_link_active", true)
    end
end

local function check_ally_distance()
	if ally == 0 or not EntityGetIsAlive(ally) then return end
	
	local ax, ay = EntityGetTransform(ally)
	local dx = ax - x
    local dy = ay - y
    local dist = math.sqrt( dx * dx + dy * dy )

    -- if the ally goes too far away, disconnect with them
    if dist > MAX_LINKED_RADIUS then
		utils.SetInternalInt( ally, "hardmod_soul_linked_ally", 0 )
		utils.SetInternalInt( owner, "hardmod_soul_linked_ally", 0 )
    	utils.EntityRemoveAllByTag( ally, "hardmod_soul_linked" )
    	EntityKill(utils.EntityGetChildByName(owner, "hardmod_soul_linked_protection"))

		-- for _,cbc in ipairs(EntityGetComponentIncludingDisabled( ally, "CameraBoundComponent" ) or {}) do
		-- 	EntitySetComponentIsEnabled( ally, cbc, true )
			-- EntityRemoveComponent( linked_enemy, cbc )
		-- end

		-- disable the owner's particles
	    for _,child in ipairs(EntityGetAllChildren(owner, "hardmod_soul_linked") or {}) do
	        EntitySetComponentsWithTagEnabled(child, "hardmod_soul_link_active", false)
	    end
    end
end

if ally == 0 or not EntityGetIsAlive(ally) then
	seek_new_ally()
else
	check_ally_distance()
end

-- finally, destroy this entity
-- EntityKill( GetUpdatedEntityID() )
