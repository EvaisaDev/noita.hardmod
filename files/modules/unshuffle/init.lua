ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.hardmod/files/modules/unshuffle/appends/perk_list.lua")

return {
	world_init = function()
		GlobalsSetValue("PERK_NO_MORE_SHUFFLE_WANDS", "1")
	end
}
