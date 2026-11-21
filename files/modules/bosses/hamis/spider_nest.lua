-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 3

local root = "mods/noita.hardmod/files/modules/bosses/"

dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile("data/scripts/items/generate_shop_item.lua")

RegisterSpawnFunction(0xffC8C800, "spawn_lamp")
RegisterSpawnFunction(0xff80FF5A, "spawn_vines")
RegisterSpawnFunction(0xff33934c, "spawn_shopitem")
RegisterSpawnFunction(0xffffeedd, "init")

RegisterSpawnFunction(0xffffd230, "spawn_empty_potion")
RegisterSpawnFunction(0xff03dead, "spawn_small_nest")

RegisterSpawnFunction(0xffff935a, "spawn_boss_nest")

g_props = {
	total_prob = 0,
	{
		prob = 0.2, min_count = 0, max_count = 0,
		offset_y = 0, entity = "",
	},
	{
		prob = 0.5, min_count = 1, max_count = 1,
		entity = "data/entities/props/physics_box_explosive.xml",
		offset_y = 0,
	},
	{
		prob = 0.5, min_count = 1, max_count = 1,
		entity = "data/entities/props/physics_propane_tank.xml",
		offset_y = 0,
	},
	{
		prob = 0.1, min_count = 1, max_count = 1,
		entity = "data/entities/props/physics_seamine.xml",
		offset_y = -8,
	},
}

g_vines = {
	total_prob = 0,
	{
		prob = 0.4, min_count = 1, max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_dark.xml"
	},
	{
		prob = 0.3, min_count = 1, max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_dark_long.xml"
	},
	{
		prob = 0.5, min_count = 1, max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_dark_short.xml"
	},
	{
		prob = 0.5, min_count = 1, max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_dark_shorter.xml"
	},
}

g_hamis = {
	total_prob = 0,
	{
		prob = 1.0, min_count = 2, max_count = 5,
		entity = "mods/noita.hardmod/files/modules/bosses/hamis/entity/animal_longleg.xml"
	},
}

function init(x, y, w, h)
	local map_w = BiomeMapGetSize()
	local half_w = map_w / 2
	local chunk_x = ((x / 512 + half_w) % map_w) - half_w

	-- print("asdsad", chunk_x)
	if chunk_x ~= -8 then return end

	local x_pos = x + 50 - 512 - 16

	LoadPixelScene(
		root.."gfx/hamis/spider_nest.png",
		root.."gfx/hamis/spider_nest_visual.png",
		x_pos, y,
		root.."gfx/hamis/spider_nest_background.png",
		true, false, {
			["ff848486"] = "smoke_static",
		}
	)
end

function spawn_shopitem(x, y) end

function spawn_small_enemies(x, y) end
function spawn_big_enemies(x, y) end
function spawn_unique_enemy(x, y) end
function spawn_items(x, y) end

function spawn_lamp(x, y) spawn(g_lamp,x,y,0,0) end
function spawn_props(x, y) spawn(g_props,x,y-3,0,0)	end
function spawn_vines(x, y) spawn(g_vines,x+5,y+5) end

function spawn_empty_potion(x, y)
	-- hint at potential potion interaction?
	EntityLoad("data/entities/items/pickup/potion_empty.xml", x, y - 2)
end

function spawn_boss_nest(x, y)
	EntityLoad("mods/noita.hardmod/files/modules/bosses/hamis/entity/boss_nest.xml", x, y)
end

function spawn_small_nest(x, y)
	-- TODO: Yoink apoth's hamis nests if conga allows
	-- otherwise just summon the vanilla hamis nest, maybe adjust it a little
	spawn(g_hamis,x,y,0,0)
end
