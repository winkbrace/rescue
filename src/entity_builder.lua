-- entity_builder.lua
-- This prototype is responsible for spawning the mining depots and enemy bases
--
local Log = require("__stdlib__/stdlib/misc/logger").new("rescue", DEBUG)

local builder = {}

function builder.get_random_position(center, radius, entity)
    local angle = math.random(0, 2 * math.pi)
    local pos = {
        x = center.x + math.ceil(radius * math.cos(angle)),
        y = center.y + math.ceil(radius * math.sin(angle)),
    }

    return game.surfaces[1].find_non_colliding_position(entity, pos, 0, 1, true)
end

function builder.spawn_depot_on_radius(radius)
    local pos = builder.get_random_position({x=0, y=0}, radius, "mining-depot")

    local direction
    if math.abs(pos.x) > math.abs(pos.y) then
        direction = pos.x > 0 and defines.direction.east or defines.direction.west
    else
        direction = pos.y > 0 and defines.direction.south or defines.direction.north
    end

    game.surfaces[1].create_entity{
        name = "mining-depot", position = pos, direction = direction,
        force = game.forces.player, raise_built = true
    }
end

function builder.spawn_enemy_base_at_depot(depot, size)
    local types = {[0] = "biter-spawner", "spitter-spawner"}
    local worms = {[0] = "small-worm-turret", "medium-worm-turret", "big-worm-turret", "behemoth-worm-turret"}
    for i = 1, size do
        local base_type = i < 3 and "biter-spawner" or types[i % 2]
        game.surfaces[1].create_entity{
            name     = base_type,
            position = builder.get_random_position(depot.position, 12, base_type),
        }
    end
    for i = 3, size do
        local worm = i < 8 and worms[i % 2] or worms[(i % 2) + 2]
        game.surfaces[1].create_entity{
            name     = worm,
            position = builder.get_random_position(depot.position, 7, worm),
            target   = depot,
        }
    end
end

return builder