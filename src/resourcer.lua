-- resourcer.lua
-- This prototype is responsible for adding additional mining resources to the game.
--
local tiers = require 'src/tiers'

local resourcer = {}

function resourcer.add_all()
    for _, tier in ipairs(tiers.all) do for item in pairs(tier) do
        resourcer.add_item_resource(item)
    end end
end

function resourcer.add_item_resource(item_name)
    -- we don't have to add resources that already exist
    if item_name == "stone" or item_name == "coal" then
        return
    end

    local item
    if item_name == "firearm-magazine" then
        item = data.raw.ammo[item_name]
    else
        item = data.raw.item[item_name]
    end

    data:extend { {
        type = "resource",
        name = item.name,
        localised_name = item.localised_name,
        icon = item.icon,
        icon_size = item.icon_size,
        flags = { "placeable-neutral" },
        order = item.order,
        map_color = resourcer.get_item_color_on_map(item_name),
        minable = {
            mining_particle = "stone-particle",
            mining_time = 1,
            result = item.name,
        },
        collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
        selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
        stage_counts = { 1 },
        stages = {
            sheet = {
                filename = item.icon,
                priority = "extra-high",
                size = 64,
                scale = 0.5,
                frame_count = 1,
                variation_count = 1,
            },
        },
    } }

    log("Resource " .. item_name .. " has been added")
end

function resourcer.get_item_color_on_map(item)
    -- Color is object of {r, g, b, a} (a = alpha, and is optional)
    local colors = {
        ["iron-plate"] = {180, 200, 255},
        ["copper-plate"] = {255, 125, 85},
        ["stone"] = {150, 100, 80},
        ["coal"] = {0, 0, 0},
        ["firearm-magazine"] = {170, 160, 54},
        ["piercing-rounds-magazine"] = {184, 32, 26},
        ["iron-gear-wheel"] = {136, 138, 132},
        ["steel-plate"] = {102, 103, 99},
        ["stone-brick"] = {107, 109, 105},
        ["copper-wire"] = {226, 174, 155},
        ["transport-belt"] = {204, 178, 136},
        ["inserter"] = {246, 207, 94},
        ["iron-stick"] = {198, 198, 198},
        ["engine-unit"] = {164, 146, 92},
        ["sulfur"] = {235, 228, 85},
        ["electronic-circuit"] = {45, 163, 14},
    }

    return colors[item]
end

return resourcer