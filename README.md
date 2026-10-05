A Noita Community Mod Collaboration! Following the Noita Fair Mod, this mod intends to make the game more difficult/challenging.

(Note that this does NOT mean adding memey bullshit or otherwise making the game more frustrating, this isn't Fairmod! The difficulty should ideally be fun and engaging.)


<ins>Development has officially begun as of October 1st</ins> and the mod will be released midnight after Halloween, or Novermber 1st 00:00 (you can still further develop/work on the mod post-release).

# Implemented Features
- `nerfed_combat_healing`
  - On taking damage, you gain a healblock status effect
  - For every 1% of max health you take as damage, you gain 2 seconds of wounded up to a maximum of 10 seconds from a single instance of damage
As you continually take more damage, the wounded timer you have can grow up to a maximum of 60 seconds, at which point it cannot be risen any higher
- `splash_text`
  - Pause menu will have a random splash message on it
- `cheeseless_triggers`
  - Trigger spells pay their payload's cast delay
  - `Add Trigger`, `Add Timer` and `Add Death Trigger` don't give free modifiers anymore and properly applies spell's cast delay
- `no_more_chainsaw_wrapping`
  - Within the cast state, chainsaw and luminous drill only give cast delay to eachother, the full state is reset to what it was *before* either of the spells was cast, once another spell is cast. This means any spell completely breaks the momentum of chainsaw.
- `trappier_traps`
  - Made a bunch of the box traps unkickable.
  - Wall traps shotgun projectiles.
- `worse_hearts`
  - Holy mountain hearts no longer grant health increase
- `no_more_max_hp_cheesing`
  - The heart mage's spell now temporarily causes you to lose max HP equal to 50% of the damage you take. This max HP is not restored afterwards.
  - Changed Matosade's related_projectiles to spawn a small worm, instead of a big one.
