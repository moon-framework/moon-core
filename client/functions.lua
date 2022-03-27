function Moon.Notification(type, text)
    local icon = ''
    local title = 'Notification'
    local message = text
    local time = 5000
    local da = MoonServerName
    if type == "error" then
        icon = 'fas fa-exclamation-circle text-danger'
        SendNUIMessage({
            action = 'open',
            sound = 'default',
            icon = icon,
            title = title,
            message = message,
            time = time,
            appname = da
        })
    elseif type == 'success' then
        icon = 'far fa-check-circle text-success'
        SendNUIMessage({
            action = 'open',
            sound = 'default',
            icon = icon,
            title = title,
            message = message,
            time = time,
            appname = da
        })
    elseif type == 'general' then
        icon = 'far fa-keyboard text-primary'
        SendNUIMessage({
            action = 'open',
            sound = 'default',
            icon = icon,
            title = title,
            message = message,
            time = time,
            appname = da
        })
    end
end
function Moon.GetPlayers()
    return GetActivePlayers()
end
Moon.TriggerCallback = function(name, cb, ...)
    Moon.Callbacks[name] = cb
    
    TriggerServerEvent('Moon:Server:TriggerCallback', name, ...)
end

