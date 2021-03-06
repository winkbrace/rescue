-- tiers.lua
-- This prototype keeps track of what item type the next outpost patch should be
--
local tiers = {
    current = 1,
    all = {
        [1] = { ["iron-plate"] = 1, ["copper-plate"] = 1, ["firearm-magazine"] = 1, ["coal"] = 1, ["stone"] = 1, },
        [2] = { ["iron-gear-wheel"] = 1, ["steel-plate"] = 1, ["stone-brick"] = 1, ["copper-cable"] = 1, },
        [3] = { ["iron-stick"] = 1, },
        [4] = { ["engine-unit"] = 1, ["sulfur"] = 1, ["electronic-circuit"] = 1, },
    },
}

function tiers.remove_item(item)
    local tier = tiers.all[tiers.current]
    for k in pairs(tier) do
        if k == item then
            tier[k] = tier[k] - 1
            if tier[k] == 0 then tier[k] = nil end
        end
    end
    tiers.all[tiers.current] = tier

    if table_size(tier) == 0 then
        tiers.current = tiers.current + 1
    end
end

-- return the next available item in the current tier
function tiers.next_item()
    item = table_random_key(tiers.all[tiers.current])
    tiers.remove_item(item)

    return item
end

return tiers;