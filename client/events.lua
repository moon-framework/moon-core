AddEventHandler('playerSpawned', function(spawn)
   MoonServer('Moon:Server:PlayerJoined')
end)

--removed old check and replaced with this new one.
RegisterNetEvent('moon:client:ToggleNC', function()
    ToggleNoClipMode()
    SetRainLevel(0.0)
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
end)

RegisterNetEvent('Moon:Client:PlayerLoaded', function(data)
    
    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z)

end)

RegisterNetEvent('printCoords', function()
    MoonServer('Moon:Server:PlayerJoined')
end)

AddEventHandler('playerDropped', function (reason)
    TriggerServerEvent('Moon:Server:PlayerUnload')
end)
  