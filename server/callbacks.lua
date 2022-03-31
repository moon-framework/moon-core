function Moon.CreateCallback(name, cb)
	Moon.ServerCallbacks[name] = cb
end

function Moon.TriggerCallback(name, requestId, source, cb, ...)
	if Moon.ServerCallbacks[name] then
		Moon.ServerCallbacks[name](source, cb, ...)
	else
		print(('[^3WARNING^7] Server callback ^5"%s"^0 does not exist. ^1Please Check The Server File for Errors!'):format(name))
	end
end

Moon.CreateCallback('Moon:Server:GetOnlinePlayers', function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(Moon.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)