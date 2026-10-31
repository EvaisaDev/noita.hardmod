---@diagnostic disable: undefined-global

for idx,perk in ipairs(perk_list) do
	if perk.id == "NO_MORE_SHUFFLE" then
		table.remove(perk_list, idx)
		break
	end
end
