Moon.Commands = {}
Moon.Commands.List = {}

function Moon.Commands.Add(name, help, arguments, argsrequired, callback, permission)
    Moon.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

RegisterNetEvent('updatecmds', function()
    Moon.Commands.Refresh(source)
end)

AddEventHandler('chatMessage', function(source, n, message)
    local src = source
    if string.sub(message, 1, 1) == '/' then
        local args = MoonShared.SplitStr(message, ' ')
        local command = string.gsub(args[1]:lower(), '/', '')
        CancelEvent()
        if Moon.Commands.List[command] then
            --local hasPerm = QBCore.Functions.HasPermission(src, QBCore.Commands.List[command].permission)
            local hasPerm = true
            local isPrincipal = IsPlayerAceAllowed(src, 'command')
            table.remove(args, 1)
            if hasPerm or isPrincipal then
                if (Moon.Commands.List[command].argsrequired and #Moon.Commands.List[command].arguments ~= 0 and args[#Moon.Commands.List[command].arguments] == nil) then
                    ---argumentstobefilled
                else
                    Moon.Commands.List[command].callback(src, args)
                    ---argumentstobefilled
                end
            else
            end
        end
    end
end)

function Moon.Commands.Refresh(source)
    local src = source
    local suggestions = {}
    if Player then
        for command, info in pairs(Moon.Commands.List) do
            suggestions[#suggestions + 1] = {
                name = '/' .. command,
                help = info.help,
                params = info.arguments
            }
        end
        TriggerClientEvent('chat:addSuggestions', tonumber(source), suggestions)
    end
end


Moon.Commands.Add('test', 'help text here', {}, false, function(source, args)
    MoonClient('moon:client:ToggleNC', source)
end)

Moon.Commands.Add('fgm', 'help text here', {}, false, function(source, args)
    MoonClient('printCoords', source)
end)