local Log = require("__stdlib__/stdlib/misc/logger").new("rescue", DEBUG)

local patcher = {
    surface = {},
    resources_to_disable = {},
}

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
        for x, _ in pairs(grid) do for y, _ in pairs(_) do
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

    for x, _ in pairs(biases) do for y, bias in pairs(_) do
        if patcher.surface.get_tile(position.x + x, position.y + y).collides_with("ground-tile") then
            patcher.surface.create_entity {
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

function patcher.find_resources_to_disable()
    for r in pairs(patcher.surface.map_gen_settings.autoplace_controls) do
        if r ~= "crude-oil" and r~= "enemy-base" and r~= "trees" then
            table.insert(patcher.resources_to_disable, r)
        end
    end
end

-- clear the world of resources
function patcher.clear()
    if next(patcher.resources_to_disable) == nil then
        patcher.find_resources_to_disable()
    end
    for _, e in pairs(patcher.surface.find_entities_filtered{type="resource", name=patcher.resources_to_disable}) do
        e.destroy()
    end
end

function patcher.set_map_gen_settings(resources, value)
    local mgs = patcher.surface.map_gen_settings
    for _, resource in ipairs(resources) do
        mgs.autoplace_controls[resource].size = value
        mgs.autoplace_controls[resource].frequency = value
        mgs.autoplace_controls[resource].richness = value
    end
    game.surfaces.nauvis.map_gen_settings = mgs
end

function patcher.regenerate_with_default_settings()
    local resources = {"iron-ore", "copper-ore", "stone", "coal"}

    patcher.set_map_gen_settings(resources, 1)

    local chunks = {}
    for x = -4, 4 do for y = -4, 4 do
        table.insert(chunks, {x, y})
    end end
    patcher.surface.regenerate_entity(resources, chunks)
end

function patcher.disable_spawning_new_resources()
    if next(patcher.resources_to_disable) == nil then
        patcher.find_resources_to_disable()
    end
    patcher.set_map_gen_settings(patcher.resources_to_disable, 0)
    patcher.set_map_gen_settings({"crude-oil"}, 1)

    Log.log("resource generation (autoplace) has been disabled for these resources:")
    Log.log(serpent.line(patcher.resources_to_disable))
end

return patcher