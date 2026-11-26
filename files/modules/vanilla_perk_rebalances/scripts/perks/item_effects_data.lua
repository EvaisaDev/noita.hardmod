local utils = dofile_once("mods/noita.hardmod/lib/utilities.lua") ---@type utils


local function func_toggle_item_gameeffects(game_effects)
	if type(game_effects) == "string" then
		game_effects = { [game_effects] = true }
	end

	return function(item, togglestate)
		for _,gec in ipairs(EntityGetComponentIncludingDisabled(item, "GameEffectComponent") or {}) do
			if game_effects[ComponentGetValue2(gec, "effect")] then
				EntitySetComponentIsEnabled(item, gec, togglestate)
			end
		end
	end
end

local function func_toggle_item_children(children_names)
	print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	if type(children_names) == "string" then
		children_names = { [children_names] = true }
	end

	return function(item, togglestate)
		print("toggling: "..item)
		print("state: "..tostring(togglestate))
		for _,child in ipairs(EntityGetAllChildren(item) or {}) do
			print("checking "..child)
			if children_names[EntityGetName(child)] then
				--EntitySetComponentsWithTagEnabled(child, "enabled_in_hand", togglestate)
				utils.set_components_enabled_delayed(child, togglestate, "enabled_in_hand")
				if togglestate then
					EntityAddComponent2(child, "LuaComponent", {
						_tags = "enabled_in_hand",
						script_source_file = "mods/noita.hardmod/lib/utility_scripts/enable_in_hand_components.lua",
						remove_after_executed = true,
					})
				else
					EntityAddComponent2(child, "LuaComponent", {
						_tags = "enabled_in_hand", --this probably doesnt work but idk if there are consequences to that and i dont wanna think about it rn.
						script_source_file = "mods/noita.hardmod/lib/utility_scripts/disable_in_hand_components.lua",
						remove_after_executed = true,
					})
				end
			end
		end
	end
end

local effect_items = {
	["data/entities/items/pickup/brimstone.xml"] = func_toggle_item_gameeffects("PROTECTION_FIRE"),
	["data/entities/items/pickup/waterstone.xml"] = func_toggle_item_gameeffects("BREATH_UNDERWATER"),
	["data/entities/items/pickup/thunderstone.xml"] = func_toggle_item_gameeffects("PROTECTION_ELECTRICITY"),
	["data/entities/items/pickup/stonestone.xml"] = func_toggle_item_children("hardmod.toxic_immunity_item"),
	["data/entities/items/pickup/wandstone.xml"] = func_toggle_item_gameeffects("EDIT_WANDS_EVERYWHERE"),
	["mods/noita.hardmod/files/modules/vanilla_perk_rebalances/entities/items/cheese.xml"] = func_toggle_item_gameeffects("PROTECTION_MELEE"),
	["data/entities/items/pickup/sun/sunseed.xml"] = func_toggle_item_gameeffects("REMOVE_FOG_OF_WAR"),
	["data/entities/items/pickup/sun/sunstone.xml"] = func_toggle_item_gameeffects("REMOVE_FOG_OF_WAR"),
	["data/entities/items/pickup/evil_eye.xml"] = function(item, state)
		EntitySetComponentsWithTagEnabled(item, "magic_eye_check", state)
	end
}

return effect_items --separate file for cachine