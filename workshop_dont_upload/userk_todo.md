# todo
- add individual perk window to eperk inspector
- switch Spells Materialised to directly read mouse inputs rather than rely on throw script_shot nonsense
- rework physics damage again
  - should be viable, but not easy one-shotting everything in second floor consistently?
  - specifics can be hammered out later, would just like it to be viable damage without being too powerful
- Add Parallel Parity module
- Look into improving early-game mobility
	- This has been done via guaranteed Hastium basin in stage 2, though more options isnt a terrible idea, wait and observe on this topic for now
- remove item immunities perk if apotheosis is enabled?
- fix zerk strat (i have a plan :> (concrete))
- move food poisoning immunity to EYV and make sure it works with vomit eperk
- make shit perk border chunkier?
- make passive spells always active in item slots with Spells materialised

## Enemy Perk Ideas
- Mass Chaotic Polymorph on death
  - Chaotically polymorphs all creatures in a large area on death
- Armed
  - Enemy spawns with a random wand that shatters on death
  - Wands are from a premade list
  - 50% of spells are dropped on death?
- Drain Field
  - Drains mana from your wands in an area
- Blinding Curser
  - only applies once?
- Aura that destroys projectiles if its been inside of it for 1 second
- thundercharge on death
- flummox projectiles 13~15s
- swapper projectiles
- material immunity
  - covered by Rival?
- extra projectiles
- iframes
- some stuff with darkness?
- mini meat realm
- blinding projectiles ~8s
- projectile-attracting projectiles
- status ailment projectile summon
- "untethered" eperk for houre
- sum fuckin larpa bullshit

## bugs
- 2nd and 3rd hand statue kicked drops summon portal spell
- Snail module crashes?
  - cause: script is defined as a coroutine: will be resolved when reimplemted with dialogue system
- make HM basin changes work in final stage
- Ira should probs remove CBC from their champion
- Bug report, 23/11/26
  - Got a bug with inventory bags mod on latest version, worked fine before.
    
    Was normal in the first biome, got the damage field perk in HM (no clue if relevant), picked up a wand in second biome. When I tried to take it out - it just disappeared. After trying to take one of the old wands, it ate it too and gave me the floating hands from hand statue mob. They killed a couple of mobs, was funny.
    
    Did a mod restart. Wands didn't come back. Was 1 left in the storage, ate it too. Then I tried to take out a potion, which disappeared as well. Instead got like 3 sets of those floating hands that killed me this time, was much less funny.

    Also, met the infected hamis, it has "fair mod" written all over it. 
- Make on-hit effects explosion stuff support not trigger on entities not hit by the explosion (account for FF accordingly)

## Compatibility
- Apply Glimmer changes to modded glimmers
- Spell Gems don't work on spells in advanced inv?

## Spell Issues
### These are not things I intend to change on my own, but with the consultation of Yui and the other devs in #noita-coommunity-collab
- Plasma does miserable damage
- linear arc is less damage for more mana than add damage
- ASE spell has 5 charges
- freeze charge is rough atm, perhaps should just be higher price + make more enemies freeze/melee immune?
- arrow is too strong? (reporter is playing with other mods, should approach critically)