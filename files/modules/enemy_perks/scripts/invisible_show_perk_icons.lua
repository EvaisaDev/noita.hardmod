local utils = dofile_once( "mods/noita.hardmod/lib/utilities.lua" ) ---@type utils

function damage_received(damage, desc, entity_who_caused, is_fatal)
	local owner = GetUpdatedEntityID()
	local eperk_entity = utils.EntityGetChildByName(owner, "hardmod.enemy_perks")
	local spr_comps = EntityGetComponentIncludingDisabled(eperk_entity, "SpriteComponent")
	if spr_comps then
		for _,spr_comp in ipairs(spr_comps or {}) do
			ComponentSetValue2(spr_comp, "visible", true)
			EntityRefreshSprite(eperk_entity, spr_comp)
		end
	end
end

function shot(proj_id)
	local owner = GetUpdatedEntityID()
	local eperk_entity = utils.EntityGetChildByName(owner, "hardmod.enemy_perks")
	local spr_comps = EntityGetComponentIncludingDisabled(eperk_entity, "SpriteComponent")
	if spr_comps then
		for _,spr_comp in ipairs(spr_comps or {}) do
			ComponentSetValue2(spr_comp, "visible", true)
			EntityRefreshSprite(eperk_entity, spr_comp)
		end
	end
end
