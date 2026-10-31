dofile_once("mods/noita.hardmod/files/modules/stronger_enemies/patcher.lua")

AddEnemies(g_big_enemies, {
	{
		prob      = 0.03,
		min_count = 1,
		max_count = 1,
		entity    = "data/entities/animals/thundermage_big.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		entity 	= "data/entities/animals/weakspirit.xml",
	},
})
