return function(hooks)
	hooks.legacy_nwt_blood_money_drops = false

	hooks.pre_processing[#hooks.pre_processing+1] = {
		id = "hardmod_blood_money_scaling",
		func = function(data)
			for _,nugget in ipairs(data.nuggets) do
				if nugget.group == "blood" then
					nugget.heal_amount = nugget.value * 0.008
				end
			end
		end
	}
end