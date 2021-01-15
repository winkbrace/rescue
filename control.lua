DEBUG = true
require("util")
local Event = require('__stdlib__/stdlib/event/event').set_protected_mode(true)
local Log = require("__stdlib__/stdlib/misc/logger").new("rescue", DEBUG)

local patcher = require 'src/patcher'
local builder = require 'src/entity_builder'
local tiers = require 'src/tiers'
local player

Event.register(Event.core_events.init, function()
    global.resources_initialized = false
    global.outpost_initialized = false
    global.outpost_distance = 6 -- in chunks
    global.enemy_base_size = 4
    global.depots = {}
    global.besieged = {}
end)

Event.register(defines.events.on_player_created, function(e)
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
        local radius = global.outpost_distance * 32
        builder.spawn_depot_on_radius(radius)

        global.outpost_initialized = true
    end
end)

Event.register(defines.events.script_raised_built, function(e)
    if e.entity.name ~= "mining-depot" then
        return
    end

    local depot = e.entity
    table.insert(global.depots, depot)
    table.insert(global.besieged, depot)

    -- message player
    game.print("New outpost discovered! Check the alert message.")
    player.add_custom_alert(depot, {type="item", name="mining-depot"}, "New outpost discovered!", true)
    Log.log("New outpost spawned at " .. serpent.line(depot.position))

    -- spawn patch
    patcher.spawn_near_depot(depot.position, tiers.next_item())
    Log.log("New patch spawned at " .. serpent.line(depot.position))

    -- spawn enemy base
    builder.spawn_enemy_base_at_depot(depot, global.enemy_base_size)
    Log.log("New enemy base of size " .. global.enemy_base_size .. " spawned at " .. serpent.line(depot.position))

    global.outpost_distance = global.outpost_distance + 1
    global.enemy_base_size = global.enemy_base_size + 1
end)

-- keep depots revealed on map
Event.register(defines.events.on_tick, function(event)
    if event.tick % 60*5 == 0 then --every 5 seconds
        for _, depot in ipairs(global.depots) do
            local pos = depot.position
            game.forces.player.chart(game.surfaces[1], {{pos.x - 16, pos.y - 16}, {pos.x + 16, pos.y + 16}})
        end
    end
end)