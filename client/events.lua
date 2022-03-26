AddEventHandler('playerSpawned', function(spawn)
   MoonServer('MServer:PlayerJoined')
end)

--removed old check and replaced with this new one.
RegisterNetEvent('MClient:ToggleNC', function()
    ToggleNoClipMode()
    SetRainLevel(0.0)
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
end)

RegisterNetEvent('MClient:PlayerLoaded', function(data)
    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z)
    MoonServer('MServer:PlayerLoaded', source)
end)

RegisterNetEvent('printCoords', function()
    MoonServer('MServer:PlayerJoined')
end)
RegisterNetEvent('printCoord2', function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('MServer:PlayerUnload', coords)
end)
AddEventHandler('playerDropped', function (reason)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('MServer:PlayerUnload', coords)
end)

Citizen.CreateThread(function()
    while true do
        Wait(300000)
        local coords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('MServer:PlayerUnload', coords)
    end
end)
