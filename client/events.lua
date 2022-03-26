AddEventHandler('playerSpawned', function(spawn)
   MoonServer('MServer::PlayerJoined')
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

end)

RegisterNetEvent('printCoords', function()
    MoonServer('MServer::PlayerJoined')
end)

AddEventHandler('playerDropped', function (reason)
    TriggerServerEvent('MServer::PlayerUnload')
end)
  