local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

utils.patchifile("data/entities/animals/boss_limbs/boss_limbs_death.lua", {
	{
		from = [["NOLLA", ]],
		insert_after = [["HARDMOD_NOTLA", "HARDMOD_RANDOM_BURST", ]]
	},
	{
		from = [[for i=1,4 do]],
		to = [[for i=1,5 do]]
	},
})

return {}
