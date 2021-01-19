local Log = {
    filename = "log.log",
    buffer = {},
    debug = false,
    last_written = 0,
    append = false,
}

function Log.new(filename, debug)
    Log.filename = filename
    Log.debug = debug

    return Log
end

function Log.log(msg)
    local function timestamp()
        if not _G.game then return "" end

        local time_s = math.floor(game.tick / 60)
        local time_minutes = math.floor(time_s / 60)
        local time_hours = math.floor(time_minutes / 60)

        return string.format('%02d:%02d:%02d ', time_hours, time_minutes % 60, time_s % 60)
    end

    if type(msg) ~= 'string' then
        msg = serpent.block(msg, {comment = false, nocode = true, sparse = true})
    end

    table.insert(Log.buffer, timestamp() .. msg .. "\n")

    -- write the log every minute
    if (Log.debug or (game.tick - Log.last_written) > 3600) then
        Log.write()
    end
end

function Log.write()
    if table_size(Log.buffer) > 0 then
        game.write_file(Log.filename, table.concat(Log.buffer), Log.append)
        Log.buffer = {}
        Log.last_written = game.tick
        Log.append = true
    end
end

return Log