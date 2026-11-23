local eid = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(eid, "AnimalAIComponent")

if not comp then return end

ComponentSetValue2(comp, "attack_ranged_action_frame", 8)
ComponentSetValue2(comp, "attack_ranged_min_distance", 1)
ComponentSetValue2(comp, "attack_ranged_max_distance", 300)
ComponentSetValue2(comp, "attack_ranged_frames_between", 80)

local glue_shot = "data/entities/projectiles/glue_shot.xml"
local glue_bomb = "mods/noita.hardmod/files/modules/bosses/hamis/projectile/glue_bomb.xml"

ComponentSetValue2(comp, "attack_ranged_entity_file", glue_bomb)

ComponentSetValue2(comp, "attack_ranged_enabled", true)
