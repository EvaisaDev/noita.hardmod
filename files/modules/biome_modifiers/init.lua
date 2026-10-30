ModLuaFileAppend("data/scripts/biome_modifiers.lua", "mods/noita.hardmod/files/modules/biome_modifiers/modifiers/patch.lua")

return {
  mod_post_init = function()
    ModLuaFileAppend("data/scripts/biome_modifiers.lua", "mods/noita.hardmod/files/modules/biome_modifiers/modifiers/list.lua")
  end,
  player_spawned = function(player)
    EntityAddComponent2(player, "BiomeTrackerComponent")
    EntityAddComponent2(player, "LuaComponent", {
      script_biome_entered = "mods/noita.hardmod/files/modules/biome_modifiers/biome_entered.lua",
      execute_every_n_frame = -1
    })
  end
}
