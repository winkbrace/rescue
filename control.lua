DEBUG = true
local Event = require('__stdlib__/stdlib/event/event').set_protected_mode(true)
local Log = require("__stdlib__/stdlib/misc/logger").new("rescue", DEBUG)

local patcher = require('prototypes/patcher')

Event.register(Event.core_events.init, function()
    global.patch_distance = 10 -- let's start at 10 chunks distance
    global.resources_initialized = false
end)

Event.register(defines.events.on_player_created, function()
    local surface = game.surfaces.nauvis

    if not global.resources_initialized then
        -- Remove all spawned resources
        patcher.clear(surface)
        patcher.regenerate_with_default_settings(surface)
        patcher.disable_spawning_new_resources(surface)

        game.print("Starting resources have been regenerated with default settings. This is all you can mine.")
        game.print("Rescue colonist outposts to gain more resources. And save their souls of course!")

        global.resources_initialized = true
    end
end)
