# Tasks
* [x] Remove advanced assemblers, miners and smelters
* [x] Remove all resources around the starting area, except for oil
* [x] Can we fix initial resource spawning to avoid people setting all to max? Or re-generate patches?
* [x] Create a 3rd force (also enemy to biters) for the initial spawns of the mining depots
      (was not required. I could disable alert_when_damaged)
* [x] Make mining depots appear at random location of increasing distance (a chunk each time)
* [x] Give the depots a LOT of life so that the player has a limited time to rescue them.
* [x] Spawn enemy bases around depots
* [ ] Create ore fields of advanced materials
* [x] Make the depots unminable
* [x] Disable recipes for mining drones and depots
* [x] When a new patch is generated, that resource should be removed from the current tier list
* [ ] When a depot is destroyed a next one should spawn at the next distance
* [ ] When a depot is liberated a next one should spawn at the next distance
* [x] Create tiers of resources. (tier1: 2x iron, 1x copper, 1x coal, 1x stone) When all resources of a tier
      have been liberated, the next generated resource is from the next tier.
* [x] Depots should have a small visibility area (like mini radars.) Rechart every 5 second for continuous visibility
* [ ] We probably need more advanced biters for the really high tier resources (another dependency?)
* [ ] When an outpost runs out, it has to be added to the current tier
* [ ] 
  
## Nice to have
* [ ] Compatibility with Krastorio 2
* [ ] Compatibility with Bob's
* [ ] i18n: https://wiki.factorio.com/Tutorial:Localisation
* [ ] 

## Settings
* [ ] Setting to make enemies attack the depots for more pressure. (no idea how to build this)
* [ ] Increase evolution when a depot is liberated

## Notes

force = "enemy", "player" or "neutral"