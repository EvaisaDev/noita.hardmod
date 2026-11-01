local _spawn_all_shopitems = spawn_all_shopitems
function spawn_all_shopitems(x, y)
	_spawn_all_shopitems(x, y)
	EntityLoad("mods/noita.hardmod/files/modules/vanilla_spell_rebalances/entities/indulgence_spawner.xml", x + 64, y)
end
