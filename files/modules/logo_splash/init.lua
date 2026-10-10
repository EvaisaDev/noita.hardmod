-- Logo splash thingy

local module = {
	gui = GuiCreate(),
	was_visible = false,
	current_splash = "",
	frame = 0,
	last_pause_was_inventory = false,
	time_paused = 0
}

local splashes = dofile_once("mods/noita.hardmod/files/modules/logo_splash/splashes.lua")

local updateSplash = function()

	-- Terrible fair mod code which i am reusing

	GuiStartFrame(module.gui)

	if module.draw_logo_splash and not module.was_visible then
		local function update_splash()
			local splash = splashes[math.random(1, #splashes)]
			
			if(splash ~= module.current_splash) then
				module.current_splash = splash
			else
				update_splash()
			end
		end
		update_splash()
		module.was_visible = true
	elseif not module.draw_logo_splash and module.was_visible then
		module.was_visible = false
	end

	if module.draw_logo_splash then
		local inputs = dofile_once("mods/noita.hardmod/lib/inputs_lists.lua")

		local function isAnyInputPressed()
			local input_checks = {
				{ inputs.mouse_codes, InputIsMouseButtonJustDown },
				{ inputs.key_codes, InputIsKeyJustDown },
				{
					inputs.joystick_codes,
					function(id)
						return InputIsJoystickButtonJustDown(0, id)
					end,
				},
				{
					inputs.thumbstick_codes,
					function(id)
						return math.abs(InputGetJoystickAnalogStick(0, id)) > 0.9
					end,
				},
				{
					inputs.trigger_codes,
					function(id)
						return InputGetJoystickAnalogButton(0, id) > 0.9
					end,
				},
			}

			for _, group in ipairs(input_checks) do
				local input_table, check_func = group[1], group[2]
				for _, id in pairs(input_table) do
					if check_func(id) then return true end
				end
			end

			return false
		end

		if isAnyInputPressed() then
			module.draw_logo_splash = false
			return
		end

		local screen_w, screen_h = GuiGetScreenDimensions(module.gui)
		local menu_distance_from_top = tonumber(MagicNumbersGetValue("UI_PAUSE_MENU_LAYOUT_TOP_EDGE_PERCENTAGE")) / 100

		local splash = module.current_splash
		module.frame = module.frame + 1

		-- splash scale sinewave
		local scale = 1.5 + math.sin(module.frame * 0.1) * 0.1

		local offset_x = 60
		local offset_y = 60

		-- Split the splash text by newline into multiple lines
		local lines = {}
		for line in splash:gmatch("([^\n]+)") do
			table.insert(lines, line)
		end

		-- Compute dimensions for each line and determine overall block size
		local max_width = 0
		local total_height = 0
		local line_dims = {}
		for _, line in ipairs(lines) do
			local w, h = GuiGetTextDimensions(module.gui, line)
			w = w * scale
			h = h * scale
			table.insert(line_dims, { w = w, h = h })
			if w > max_width then
				max_width = w
			end
			total_height = total_height + h
		end

		-- Center the block of text and apply offsets
		local block_x = screen_w / 2 - max_width / 2 + offset_x
		local block_y = screen_h * menu_distance_from_top - total_height / 2 + offset_y

		-- Draw each line with proper positioning
		local current_y = block_y
		for i, line in ipairs(lines) do
			local dims = line_dims[i]
			-- Center each line within the block
			local line_x = block_x + (max_width - dims.w) / 2
			
			GuiZSetForNextWidget(module.gui, -1000000)
			GuiColorSetForNextWidget(module.gui, 1, 1, 0, 1)
			GuiText(module.gui, line_x, current_y, line, scale)
			current_y = current_y + dims.h
		end

		local logo_w, logo_h = GuiGetImageDimensions(module.gui, "data/ui_gfx/pause_menu/noita_logo.png")
		local logo_x = screen_w / 2 - logo_w / 2
		local logo_y = screen_h * menu_distance_from_top - logo_h / 2

		local logo_offset_x = 0
		local logo_offset_y = 40

		logo_x = logo_x + logo_offset_x
		logo_y = logo_y + logo_offset_y

		-- Uncomment if you want to draw the logo image
		-- GuiImage(module.gui, new_id(), logo_x, logo_y, "mods/noita.fairmod/files/content/logo_splash/noita_logo.png", 1, 1, 1, 0)

	end
end

module.pause_changed = function(is_paused, is_inventory_pause)
	module.last_pause_was_inventory = is_inventory_pause


	if is_paused and not is_inventory_pause then
		-- regular pause screen
	elseif is_paused and is_inventory_pause then
		-- inventory pause screen
	elseif not is_paused then
		-- unpaused
		module.draw_logo_splash = false
		module.time_paused = 0
	end	
end

module.pre_update = function(frame)
	updateSplash()
end

module.pause_pre_update = function()
	module.time_paused = module.time_paused + 1

	if(InputIsKeyDown(41))then
		module.pause_button_pressed = true
	end

	if not module.last_pause_was_inventory and module.pause_button_pressed and module.time_paused == 5 then
		module.draw_logo_splash = true
		module.pause_button_pressed = false
	end
	updateSplash()
end

return module
