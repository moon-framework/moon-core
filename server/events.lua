------------------ Accounts ------------------
RegisterNetEvent('Moon:Server:CheckAccount', function()
    local src = source
    Moon.CheckAccounts(src)
end)

RegisterNetEvent('Moon:Server:AssignSID')
AddEventHandler(('Moon:Server:AssignSID'), function (source)
    local src = source
    Moon.AssignSID(src)
end)

----------------- CallBack ----------------------

RegisterServerEvent('Moon:Server:TriggerCallback')
AddEventHandler('Moon:Server:TriggerCallback', function(name, requestId, ...)
	local playerId = source

	Moon.TriggerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('moon:serverCallback', playerId, requestId, ...)
	end, ...)
end)
---------------- Inventory Events ----------------

RegisterNetEvent('Moon:Server:UseItem', function(item)
    local src = source
    Moon.Functions.UseItem(src, item)
end)


RegisterNetEvent('checkforitemamount', function(plate)
    local license = Moon.GetLicense(source)
    local result = exports.oxmysql:fetchSync('SELECT * FROM inventories WHERE identifier = ? ', {license})
    if result[1] then
        local inv = json.decode(result[1].data)
        if inv.amount == 0 then
            exports.oxmysql:execute('DELETE FROM inventories WHERE id = ?', {result[1].id})
        end
    end
    local resultb = exports.oxmysql:fetchSync('SELECT * FROM vehiclesdata WHERE plate = ?',{plate})
    if resultb[1] then
        local inv = json.decode(resultb[1].data)
        if inv.amount == 0 then
            exports.oxmysql:execute('DELETE FROM vehiclesdata WHERE plate = ?', {plate})
        end
    end
end)


----------------------- Chat/Commands events --------------------------

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
