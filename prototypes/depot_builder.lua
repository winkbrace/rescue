local Log = require("__stdlib__/stdlib/misc/logger").new("rescue", DEBUG)

local depot_builder = {}

function depot_builder.spawn_on_radius(radius)
    local angle = math.random(0, 2 * math.pi)
    local pos = {
        x = math.ceil(radius * math.cos(angle)),
        y = math.ceil(radius * math.sin(angle)),
    }

    pos = game.surfaces[1].find_non_colliding_position("mining-depot", pos, 50, 1, true)

    local direction
    if math.abs(pos.x) > math.abs(pos.y) then
        direction = pos.x > 0 and defines.direction.east or defines.direction.west
    else
        direction = pos.y > 0 and defines.direction.south or defines.direction.north
    end

    depot = game.surfaces[1].create_entity{
        name = "mining-depot", position = pos, direction = direction,
        force = game.forces.player, raise_built = true
    }

    return pos
end

return depot_builder