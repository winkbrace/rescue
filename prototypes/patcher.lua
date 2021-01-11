local Log = require("__stdlib__/stdlib/misc/logger").new("rescue", DEBUG)

local patcher = {}

function patcher.spawn(position, item, amount)
    print("spawning patch at (" .. position.x .. "," .. position.y .. ")")

    local tiles = 512
    local w_max = 16
    local h_max = 16

    local biases = { [0] = { [0] = 1 } }
    local t = 1

    local function grow(grid, t)
        local old = {}
        local new_count = 0
        for x, _ in pairs(grid) do for y, __ in pairs(_) do
            table.insert(old, { x, y })
        end end
        for _, pos in pairs(old) do
            local x, y = pos[1], pos[2]
            for dx = -1, 1, 1 do for dy = -1, 1, 1 do
                local a, b = x + dx, y + dy
                if (math.random() > 0.9) and (math.abs(a) < w_max) and (math.abs(b) < h_max) then
                    grid[a] = grid[a] or {}
                    if not grid[a][b] then
                        grid[a][b] = 1 - (t / tiles)
                        new_count = new_count + 1
                        if (new_count + t) == tiles then return new_count end
                    end
                end
            end end
        end
        return new_count
    end

    repeat
        t = t + grow(biases, t)
    until t >= tiles

    local total_bias = 0
    for x, _ in pairs(biases) do for y, bias in pairs(_) do
        total_bias = total_bias + bias
    end end

    local surface = game.player.surface
    for x, _ in pairs(biases) do for y, bias in pairs(_) do
        if surface.get_tile(position.x + x, position.y + y).collides_with("ground-tile") then
            surface.create_entity {
                name = item,
                amount = amount * (bias / total_bias),
                force = 'neutral',
                position = { position.x + x, position.y + y },
            }
        end
    end end
end

function patcher.spawn_on_radius(radius, item, amount)
    local angle = math.random(0, 2 * math.pi)
    local position = {
        x = math.ceil(radius * math.cos(angle)),
        y = math.ceil(radius * math.sin(angle)),
    }

    patcher.spawn(position, item, amount)
end

-- clear a chunk of resources if it's outside the starting area
function patcher.clear(surface)
    for _, e in pairs(surface.find_entities_filtered{type="resource"}) do
        e.destroy()
    end
end

function patcher.regenerate_with_default_settings(surface)
    local resources = {"iron-ore", "copper-ore", "stone", "coal"}
    local mgs = surface.map_gen_settings
    for _, resource in ipairs(resources) do
        mgs.autoplace_controls[resource].size = "normal"
        mgs.autoplace_controls[resource].frequency = "normal"
        mgs.autoplace_controls[resource].richness = "normal"
    end
    game.surfaces.nauvis.map_gen_settings = mgs

    local chunks = {}
    for x = -3, 3 do for y = -3, 3 do
        table.insert(chunks, {x, y})
    end end
    surface.regenerate_entity(resources, chunks)
end

function patcher.disable_spawning_new_resources(surface)
    local mgs = surface.map_gen_settings
    for _, resource in ipairs({"iron-ore", "copper-ore", "uranium-ore", "stone", "coal"}) do
        mgs.autoplace_controls[resource].size = "none"
        mgs.autoplace_controls[resource].frequency = "none"
        mgs.autoplace_controls[resource].richness = "none"
    end
    game.surfaces.nauvis.map_gen_settings = mgs
end

return patcher