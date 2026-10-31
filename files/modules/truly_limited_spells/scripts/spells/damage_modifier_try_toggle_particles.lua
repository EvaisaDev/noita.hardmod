local EZWand = dofile_once( "mods/noita.hardmod/lib/ezwand.lua" )

local eligible_spell_ids = "HARDMOD_SPELL_DAMAGE_DOUBLE,HARDMOD_SPELL_OVERKILL"

local function get_all_wand_actions( wand )
	local actions = {}
	local spells, always_casts = wand:GetSpells()
	for i,always_cast in ipairs( always_casts ) do
		table.insert( actions, always_cast )
	end
	for i,spell in ipairs( spells ) do
		table.insert( actions, spell )
	end

	return actions
end

local held_wand = EZWand.GetHeldWand()
if held_wand == nil then return end
local spells_in_wand = get_all_wand_actions( held_wand )

local show_particles = false
for i,spell in ipairs( spells_in_wand ) do
	if string.find( eligible_spell_ids, spell.action_id ) then
		local item_comp = EntityGetFirstComponentIncludingDisabled( spell.entity_id, "ItemComponent" )
		if item_comp ~= nil then
	        local uses_remaining = ComponentGetValue2( item_comp, "uses_remaining" )
			if uses_remaining > 0 then
				show_particles = true
			end
		end
	end
end

local particle_comp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "ParticleEmitterComponent" )
if particle_comp then
	ComponentSetValue2( particle_comp, "is_emitting", show_particles )
end
