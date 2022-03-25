Citizen.CreateThread(function()
    TriggerServerEvent('updatecmds')
end)

MoonServer = function(protectedByRaisen, ...)
    local args = ...
    TriggerServerEvent(protectedByRaisen, ...)
end



--basically, when any server event is triggered outside MoonServer function will result in a ban.
--this requires a check done in every event handler.
--same goes for client-events.
  