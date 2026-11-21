local eid = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(eid, "AnimalAIComponent")

if not comp then return end

ComponentSetValue2(comp, "attack_ranged_action_frame", 8)
ComponentSetValue2(comp, "attack_ranged_min_distance", 1)
ComponentSetValue2(comp, "attack_ranged_max_distance", 160)
ComponentSetValue2(comp, "attack_ranged_frames_between", 30)

ComponentSetValue2(comp, "attack_ranged_entity_file", "data/entities/projectiles/glue_shot.xml")

ComponentSetValue2(comp, "attack_ranged_enabled", true)
