RegisterNetEvent('Moon:Client:PlayerJoined')
AddEventHandler('Moon:Client:PlayerJoined', function()
    TriggerServerEvent('Moon:Server:PlayerJoined')
end)