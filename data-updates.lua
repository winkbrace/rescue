DEBUG = true
local Recipe = require("__stdlib__/stdlib/data/recipe")

-- These are the basic assembling entities that are allowed. Any more advanced will be removed
-- We use the trick of using the values as key so we can use entities_to_keep[entity] in an if condition
local entities_to_keep = {
    ["burner-mining-drill"] = true,
    ["pumpjack"] = true, -- I'm scared of trying to make the drones mine fluids
    ["stone-furnace"] = true,
}
-- We collect the entities in "removed_entities" so we know what technologies to remove afterwards
local removed_entities = {}

-- Remove all advanced assemblers, miners and smelters
for _, type in ipairs({"mining-drill", "furnace"}) do
    for entity in pairs(data.raw[type]) do
        if entities_to_keep[entity] then
            data.raw[type][entity].next_upgrade = nil
        else
            log("Entity removed by Rescue: " .. entity)
            data.raw[type][entity] = nil
            data.raw.item[entity] = nil
            data.raw.recipe[entity] = nil
            removed_entities[entity] = true
        end
    end
end

-- Remove entity unlocks from technologies
for key, technology in pairs(data.raw.technology) do
    for i, effect in ipairs(technology.effects or {}) do
        if effect.type == "unlock-recipe" and removed_entities[effect.recipe] then
            table.remove(data.raw.technology[key].effects, i)
        end
    end
end

-- Adjust purple science recipe to require substation instead of electric furnace
Recipe("production-science-pack"):replace_ingredient("electric-furnace", "substation")

-- The player should not be able to build mining drones or depots
data.raw.recipe["mining-depot"] = nil
data.raw.recipe["mining-drone"] = nil

-- Depots should not be minable by the player. Also give them lots of life.
data.raw["assembling-machine"]["mining-depot"].minable = nil
data.raw["assembling-machine"]["mining-depot"].max_health = 1e6 -- originally was 400
data.raw["assembling-machine"]["mining-depot"].alert_when_damaged = false

-- Remove tips & tricks that trigger when something related to our removed buildings happens
data.raw["tips-and-tricks-item"]["fast-replace"] = nil
data.raw["tips-and-tricks-item"]["fast-replace-belt-splitter"] = nil
data.raw["tips-and-tricks-item"]["fast-replace-belt-underground"] = nil

-- add our custom mining resources
(require 'src/resourcer').add_all()