DEBUG = true
require "src/util"

local Log = require("src/logger").new("Rescue/rescue.log", DEBUG)
local patcher = require "src/patcher"
local builder = require "src/entity_builder"
local tiers = require "src/tiers"
local tracker = require "tracker"
local player

script.on_init(function()
    global.log = Log.log
    -- outpost creation parameters
    global.resources_initialized = false
    global.outpost_initialized = false
    global.outpost_distance = 6 -- in chunks
    global.enemy_base_size = 4
    -- tracker
    global.depots = {}
    global.spawners = {}
    global.resources = {}
end)

-- initialize game: remove normal resources and spawn outpost
script.on_event(defines.events.on_player_created, function(e)
    player = game.players[e.player_index]
    patcher.surface = game.surfaces.nauvis

    if not global.resources_initialized then
        patcher.clear()
        patcher.regenerate_with_default_settings()
        patcher.disable_spawning_new_resources()

        -- TODO figure out text colors / format
        game.print("Starting resources have been regenerated with default settings. This is all you can mine.")
        game.print("Rescue colonist outposts to gain more resources. Oh, and rescue their butts of course!")

        global.resources_initialized = true
    end

    if not global.outpost_initialized then
        builder.spawn_depot_on_radius(global.outpost_distance)

        global.outpost_initialized = true
    end
end)

-- spawn resources and biter nest when outpost was created
script.on_event(defines.events.script_raised_built, function(e)
    if e.entity.name ~= "mining-depot" then return end

    local depot = e.entity
    tracker.add_depot(depot)

    -- message player
    game.print("New outpost discovered! Check the alert message.")
    player.add_custom_alert(depot, {type="item", name="mining-depot"}, "New outpost discovered!", true)
    global.log("New outpost spawned at " .. serpent.line(depot.position))

    -- spawn patch
    patcher.spawn_near_depot(depot, tiers.next_item())
    global.log("New patch spawned near " .. serpent.line(depot.position))

    -- spawn enemy base
    builder.spawn_enemy_bases_at_depot(depot, global.enemy_base_size)
    global.log("New enemy base of size " .. global.enemy_base_size .. " spawned around " .. serpent.line(depot.position))

    -- prepare for next outpost
    global.outpost_distance = global.outpost_distance + 1
    global.enemy_base_size  = global.enemy_base_size + 1
end)

-- keep depots revealed on map
script.on_event(defines.events.on_tick, function(e)
    -- every 5 second
    if e.tick % (60 * 5) == 0 then
        for _, depot in pairs(global.depots) do
            local pos = depot.position
            game.forces.player.chart(game.surfaces[1], {{pos.x - 16, pos.y - 16}, {pos.x + 16, pos.y + 16}})
        end
    end
end)

-- when outpost is liberated, give it drones, and spawn new outpost
script.on_event(defines.events.on_entity_destroyed, function(e)
    local remaining_spawners, depot = tracker.remove_spawner(e.registration_number)
    if remaining_spawners == 0 then
        -- give depot drones
        builder:add_drones(depot)

        -- spawn new outpost
        builder.spawn_depot_on_radius(global.outpost_distance)
    end
end)