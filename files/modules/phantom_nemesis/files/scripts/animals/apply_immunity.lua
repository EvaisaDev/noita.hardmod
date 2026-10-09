local ability_id = GetUpdatedEntityID()
local host_id = EntityGetRootEntity(ability_id)
local vsc_comp = EntityGetFirstComponentIncludingDisabled(ability_id,"VariableStorageComponent") or 0
local damagetype = ComponentGetValue2(vsc_comp,"value_string")
local dmg_comp = EntityGetFirstComponentIncludingDisabled(host_id,"DamageModelComponent") or 0
ComponentObjectSetValue2(dmg_comp,"damage_multipliers",damagetype,0)