local level = 4
local extra_level = 4
local max_extras = 2

return function (x, y)
  SetRandomSeed(x, y)
  local extras = Random(1, max_extras)

  SpawnActionItem(x, y, level)

  x = x - 10 * (extras / 2)

  for _=1,extras do
    SpawnActionItem(x, y - 5, extra_level)
    x = x + 10
  end

  if not GameHasFlagRun("repaired_broken_spell") then
	GameAddFlagRun("repaired_broken_spell")
	CreateItemActionEntity("SUMMON_PORTAL", x - 5, y - 5)
  end
end
