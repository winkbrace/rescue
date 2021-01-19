-- this c++ function has been provided by factorio
-- table_size(table)

function table_random_key(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end

    return keys[math.random(#keys)]
end