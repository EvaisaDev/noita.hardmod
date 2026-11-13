local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils

local materials = {
	{
		material = "water",
		weight = 10,
	}
}


local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)
SetRandomSeed(x-10, y+18541)


local mat = utils.RandomFromTable(materials)
AddMaterialInventoryMaterial(entity_id, mat.material, mat.amount or 1000)