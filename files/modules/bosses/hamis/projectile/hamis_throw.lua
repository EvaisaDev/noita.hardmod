local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/egg/hatch", x, y)

local hamis = EntityLoad(
	"mods/noita.hardmod/files/modules/bosses/hamis/entity/longleg.xml",
	x, y
)

EntityAddComponent2(hamis, "LifetimeComponent", {
	lifetime = 15 * 60
})
