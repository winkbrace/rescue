# Tasks
* [x] Remove advanced assemblers, miners and smelters
* [x] Remove all resources around the starting area, except for oil
* [x] Can we fix initial resource spawning to avoid people setting all to max? Or re-generate patches?
* [ ] Create a 3rd force (also enemy to biters) for the initial spawns of the mining depots
* [ ] Make mining depots appear at random location of increasing distance (a chunk each time)
* [ ] Give the depots a LOT of life so that the player has a limited time to rescue them.
* [ ] Spawn biter bases around depots
* [ ] Create ore fields of advanced materials
* [ ] Make the depots unminable
* [ ] Disable recipes for mining drones and depots
* [ ] When a depot is destroyed a same one should spawn at the next distance
* [ ] When a depot is liberated a next one should spawn at the next distance
* [ ] Create tiers of resources. (tier1: 2x iron, 1x copper, 1x coal, 1x stone) When all resources of a tier
      have been liberated, the next generated resource is from the next tier.
* [ ] Depots should have a small visibility area (like mini radars.)
  
      local pos = ??get-depot??.position
      local radius = 5
      game.player.force.chart(game.player.surface, {{pos.x - radius, pos.y - radius}, {pos.x + radius, pos.y + radius}})
* [ ] Evolution is increased when a depot is liberated
* [ ] We probably need more advanced biters for the really high tier resources (another dependency?)
* [ ] 
  
## Nice to have
* [ ] Compatibility with Krastorio 2
* [ ] Compatibility with Bob's
* [ ] 

## Notes

force = "enemy", "player" or "neutral"