function table_count(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end

    return count
end

function table_random_key(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end

    return keys[math.random(#keys)]
end