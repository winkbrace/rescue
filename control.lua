DEBUG = true
require("util")
local Event = require('__stdlib__/stdlib/event/event').set_protected_mode(true)
local Log = require("__stdlib__/stdlib/misc/logger").new("rescue", DEBUG)

local patcher = require 'prototypes/patcher'
local builder = require 'prototypes/depot_builder'
local tiers = require 'prototypes/tiers'
local player

Event.register(Event.core_events.init, function()
    global.resources_initialized = false
    global.outpost_initialized = false
    global.outpost_distance = 6 -- in chunks
    global.enemy_base_size = 4
end)

Event.register(defines.events.on_player_created, function(e)
    player = game.players[e.player_index]
    patcher.surface = game.surfaces.nauvis

    if not global.resources_initialized then
        patcher.clear()
        patcher.regenerate_with_default_settings()
        patcher.disable_spawning_new_resources()

        game.print("Starting resources have been regenerated with default settings. This is all you can mine.")
        game.print("Rescue colonist outposts to gain more resources. Oh, and rescue their butts of course!")

        global.resources_initialized = true
    end

    if not global.outpost_initialized then
        local radius = global.outpost_distance * 32
        builder.spawn_on_radius(radius)

        global.outpost_initialized = true
    end
end)

Event.register(defines.events.script_raised_built, function(e)
    if e.entity.name ~= "mining-depot" then
        return
    end
    local depot = e.entity

    -- message player
    local msg = "New outpost discovered at " .. serpent.line(depot.position)
    game.print(msg)
    player.add_custom_alert(depot, {type="item", name="mining-depot"}, msg, true)
    Log.log(msg)

    -- spawn patch
    patcher.spawn_near_depot(depot.position, "iron-ore")  -- TODO tiers.next_item()
    Log.log("New patch spawned at " .. serpent.line(depot.position))

    -- TODO spawn enemy bases

    global.outpost_distance = global.outpost_distance + 1
end)