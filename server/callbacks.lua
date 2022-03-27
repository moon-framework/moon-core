function Moon.CreateCallback(name, cb)
    Moon.Callbacks[name] = cb
end

Moon.CreateCallback('Moon:Server:GetOnlinePlayers', function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(Moon.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)