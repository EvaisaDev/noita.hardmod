if actions ~= nil then
	local actions_to_edit = {
		["WORM_RAIN"] = {
			related_projectiles = {"data/entities/animals/worm.xml"},
		},
	}

	for i=1,#actions do
        if actions_to_edit[actions[i].id] then
            for key, value in pairs(actions_to_edit[actions[i].id]) do
                actions[i][key] = value
            end
            actions[i]['hardmod_reworked'] = true
        end
    end
end