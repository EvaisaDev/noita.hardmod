dofile("data/scripts/lib/mod_settings.lua")

--Key binding data
local listening_alt_fire = false
local there_has_been_input = false
local old_binding = 0
local current_keybind = ""
--Key binding strings
local keybind_name = "Keybind"
local keybind_desc_altfire = "Edit your Alt Fire keybind"
local keybind_tutorial_altfire = "\nHit the prompt below to input a new alt-fire binding.\nThe default setting is the right mouse button."
local keybind_newbinding = "SET NEW BINDING"
local keybind_current = "Current binding: "

function has_value (table, value)
  for _, v in ipairs(table) do
      if v == value then
          return true
      end
  end
  return false
end

function input_listen(key_inputs,mouse_inputs,joystick_inputs,mod_setting)
	local inputs = dofile_once("mods/noita.hardmod/lib/inputs_lists.lua")

	local there_is_input = false
	for _, code in pairs(inputs.key_codes) do
		if InputIsKeyDown(code) then
			there_is_input = true
			there_has_been_input = true
			if has_value(key_inputs, code) == false then
				table.insert(key_inputs, code)
			end
		end
	end
	for _, code in pairs(inputs.mouse_codes) do
		if InputIsMouseButtonDown(code) then
			there_is_input = true
			there_has_been_input = true
			if has_value(mouse_inputs, code) == false then
				table.insert(mouse_inputs, code)
			end
		end
	end
	for _, code in pairs(inputs.joystick_codes) do
		if InputIsJoystickButtonDown(0, code) then
			there_is_input = true
			there_has_been_input = true
			if has_value(joystick_inputs, code) == false then
				table.insert(joystick_inputs, code)
			end
		end
	end

	--Decided variable forces only a single keybind for input and blocks combo inputs, can be remove to disable this limiter
	local decided = false
	local binding = "key_code,"
	for _, code in pairs(key_inputs) do
		if decided == true then break end
		binding = table.concat({binding,tostring(code),","})
		decided = true
	end
	binding = binding .. "mouse_code,"
	for _, code in pairs(mouse_inputs) do
		if decided == true then break end
		binding = table.concat({binding,tostring(code),","})
		decided = true
	end
	binding = binding .. "joystick_code,"
	for _, code in pairs(joystick_inputs) do
		if decided == true then break end
		binding = table.concat({binding,tostring(code),","})
		decided = true
	end
	binding = binding:sub(1, -2)
	ModSettingSet( mod_setting, binding )

	if there_has_been_input and not there_is_input then
		listening_alt_fire = false
		listening_mid_fire = false
		listening_beacon = false
		there_has_been_input = false
		key_inputs = {}
		mouse_inputs = {}
		joystick_inputs = {}
		if ModSettingGet( mod_setting ) == "key_code,mouse_code,joystick_code" then
		  ModSettingSet( mod_setting, old_binding )
		end
	end
end

local mod_id = "noita.hardmod" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
    {
        category_id = "alt_fire_settings",
        ui_name = "Alt Fire Anything",
        ui_description = "Which button should be used to cast Alt Fire Anything?",
        foldable = true,
        _folded = true,
        settings = {
            {
                id = "alt_fire_keybind",
                ui_name = "Keybind",
                value_default = "key_code,mouse_code,2,joystick_code",
                ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
							local inputs = dofile_once("mods/noita.hardmod/lib/inputs_lists.lua")

                            if listening_alt_fire then
                                input_listen(key_inputs,mouse_inputs,joystick_inputs,"noita.hardmod.alt_fire_keybind")
                            end

                            local _id = 0
                            local function id()
                              _id = _id + 1
                              return _id
                            end

                            local keybind_string = ""
                            local keybind_setting = ModSettingGet("noita.hardmod.alt_fire_keybind")
                            local mode = "key_code"
                            for code in string.gmatch(keybind_setting, "[^,]+") do
                              if code == "mouse_code" or code == "key_code" or code == "joystick_code" then
                                  mode = code
                              else
                                  if keybind_string ~= "" then
                                      keybind_string = keybind_string .. " + "
                                  end
                                  code = tonumber(code)
                                  if mode == "key_code" then
                                      for key, value in pairs(inputs.key_codes) do
                                          if value == code then
                                              keybind_string = keybind_string .. key
                                              ModSettingSet("noita.hardmod.alt_fire_keybind_translated",key)
                                          end
                                      end
                                  elseif mode == "mouse_code" then
                                      for key, value in pairs(inputs.mouse_codes) do
                                          if value == code then
                                              keybind_string = keybind_string .. key
                                              ModSettingSet("noita.hardmod.alt_fire_keybind_translated",key)
                                          end
                                      end
                                  elseif mode == "joystick_code" then
                                      for key, value in pairs(inputs.joystick_codes) do
                                          if value == code then
                                              keybind_string = keybind_string .. key
                                              ModSettingSet("noita.hardmod.alt_fire_keybind_translated",key)
                                          end
                                      end
                                  end
                              end
                            end

                            GuiColorSetForNextWidget(gui, 1, 1, 1, 0.5)
                            GuiText(gui, 5, 0, keybind_tutorial_altfire)
                            if listening_alt_fire then
                              GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
                              GuiOptionsAdd(gui, GUI_OPTION.NonInteractive)
                            end
                            if GuiButton(gui, id(), 10, 5, keybind_newbinding) then
                              key_inputs = {}
                              mouse_inputs = {}
                              joystick_inputs = {}
                              listening_alt_fire = true
                              listening_mid_fire = false
                              listening_beacon = false
                              there_has_been_input = false
                              old_binding = ModSettingGet("noita.hardmod.alt_fire_keybind")
                            end
                            GuiColorSetForNextWidget(gui, 1, 1, 1, 0.5)
                            GuiText(gui, 5, 5, keybind_current .. keybind_string)
                            GuiText(gui, 0, -5, " ")
                            end
            },
            {
                id = "alt_fire_keybind_translated",
                ui_name = "Secret setting",
                value_default = "MOUSE_RIGHT",
                text_max_length = 20,
                allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789",
                hidden = true,
            },
            {
                id = "alt_fire_enable_in_inventory",
                ui_name = "Enable Alt Fire Anything while inventory is open",
                ui_description = "When enabled, Alt Fire Anything will also function\nwhen the inventory is opened.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_RUNTIME,
            },
        },
    },
}

function ModSettingsUpdate(init_scope)
    local old_version = mod_settings_get_version(mod_id)
    mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

-- function ModSettingsGui(gui, in_main_menu)
--     mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
-- end

-- This function is called to display the settings UI for this mod.
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
    screen_width, screen_height = GuiGetScreenDimensions(gui)

    mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )

    local id = 46323
    local function new_id() id = id + 1; return id end

    GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )

    for i = 1, 5 do
        GuiText( gui, 0, 0, "" )
    end
    --GuiLayoutEnd(gui)
end