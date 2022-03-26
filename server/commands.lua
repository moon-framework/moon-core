Moon.CreateCMD = {}
Moon.CreateCMD.List = {}

function Moon.CreateCMD.New(name, help, arguments, argsrequired, callback, permission)
    Moon.CreateCMD.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

RegisterNetEvent('updatecmds', function()
    Moon.CreateCMD.Refresh(source)
end)

AddEventHandler('chatMessage', function(source, n, message)
    local src = source
    if string.sub(message, 1, 1) == '/' then
        local args = MoonShared.SplitStr(message, ' ')
        local command = string.gsub(args[1]:lower(), '/', '')
        CancelEvent()
        if Moon.CreateCMD.List[command] then
            local hasPerm = true
            local isPrincipal = IsPlayerAceAllowed(src, 'command')
            table.remove(args, 1)
            if hasPerm or isPrincipal then
                if (Moon.CreateCMD.List[command].argsrequired and #Moon.CreateCMD.List[command].arguments ~= 0 and args[#Moon.CreateCMD.List[command].arguments] == nil) then
                    ---argumentstobefilled
                else
                    Moon.CreateCMD.List[command].callback(src, args)
                    ---argumentstobefilled
                end
            else

            end
        end
    end
end)

function Moon.CreateCMD.Refresh(source)
    local src = source
    local suggestions = {}
    if Player then
        for command, info in pairs(Moon.CreateCMD.List) do
            suggestions[#suggestions + 1] = {
                name = '/' .. command,
                help = info.help,
                params = info.arguments
            }
        end
        TriggerClientEvent('chat:addSuggestions', tonumber(source), suggestions)
    end
end


Moon.CreateCMD.New('test', 'help text here', {}, false, function(source, args)
    MoonClient('MClient:ToggleNC', source)
end)

Moon.CreateCMD.New('fgm', 'help text here', {}, false, function(source, args)
    MoonClient('printCoords', source)
end)
Moon.CreateCMD.New('dalailama', 'help text here', {}, false, function(source, args)
    MoonClient('printCoord2', source)
end)