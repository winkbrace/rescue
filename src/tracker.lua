local tracker = {}

local function make_id(building)
    return building.position.x .. ',' .. building.position.y
end

function tracker.add_depot(depot)
    global.depots[make_id(depot)] = depot
end

function tracker.register_resource_at_depot(depot, resource)
    global.resources[make_id(depot)] = resource
end

function tracker.get_depot_resource(depot)
    return global.resources[make_id(depot)]
end

function tracker.register_spawner_at_depot(depot, reg_id)
    local id = make_id(depot)
    if global.spawners[id] ~= nil then
        global.spawners[id][reg_id] = 1
    else
        global.spawners[id] = {[reg_id] = 1}
    end
end

function tracker.remove_spawner(reg_id)
    for depot_id, spawners in pairs(global.spawners) do
        for spawn_reg_id in pairs(spawners) do
            if spawn_reg_id == reg_id then
                global.spawners[depot_id][reg_id] = nil
                return table_size(global.spawners[depot_id]), global.depots[depot_id]
            end
        end
    end
end

return tracker