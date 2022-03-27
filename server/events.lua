RegisterNetEvent('updatecmds', function()
    Moon.CreateCMD.Refresh(source)
end)

RegisterNetEvent('Moon:Server:CheckAccount', function()
    local src = source
    Moon.CheckAccounts(src)
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