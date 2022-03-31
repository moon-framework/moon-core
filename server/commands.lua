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

function Moon.CreateCMD.Refresh(source)
    local src = source
    local suggestions = {}
    for command, info in pairs(Moon.CreateCMD.List) do
        suggestions[#suggestions + 1] = {
            name = '/' .. command,
            help = info.help,
            params = info.arguments
        }
    end
    TriggerClientEvent('chat:addSuggestions', tonumber(source), suggestions)
end