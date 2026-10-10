possession_limit_per_biome = {
    {id="$biome_coalmine",limit=1},
    {id="$biome_coalmine_alt",limit=1},
    {id="$biome_forest",limit=2},
    {id="$biome_holymountain",limit=0},
    {id="$biome_excavationsite",limit=1},
    {id="$biome_fungicave",limit=1},
    {id="$biome_snowcave",limit=1},
    {id="$biome_snowcastle",limit=2},
    {id="$biome_rainforest",limit=2},
    {id="$biome_rainforest_dark",limit=3},
    {id="$biome_vault",limit=2},
    {id="$biome_crypt",limit=3},
    {id="$biome_desert",limit=6},
    {id="$biome_fungiforest",limit=6},
    {id="$biome_meat",limit=3},
    {id="$biome_robobase",limit=3},
    {id="$biome_winter_caves",limit=20},
    {id="$biome_boss_victoryroom",limit=-1}
}

default_biome_limit = 4

return {
    possession_limit_per_biome   = possession_limit_per_biome,
    default_biome_limit         = default_biome_limit,
}