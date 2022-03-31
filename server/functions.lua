Moon.CheckBanned = function(source)
    local src = source
    local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {Moon.GetLicense(src)})
    if result[1] then
        if result[1].Banned then
            return true
        else
            return false
        end
    end
end

function Moon.TriggerCallback(name, cb, ...)
	Moon.ServerCallbacks[Moon.CurrentRequestId] = cb

	TriggerServerEvent('Moon:Server:TriggerCallback', name, Moon.CurrentRequestId, ...)

	if Moon.CurrentRequestId < 65535 then
		Moon.CurrentRequestId = Moon.CurrentRequestId + 1
	else
		Moon.CurrentRequestId = 0
	end
end

Moon.CheckAccounts = function(source)
    local src = source
    local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {Moon.GetLicense(src)})
    if not result[1] then
        local PlayerData = {
            Firstname = 'Firstname',
            Lastname = 'Lastname',
            Gender = 'Male',
            Age = 0,
            X = MoonDefaultSpawn.X,
            Y = MoonDefaultSpawn.Y,
            Z = MoonDefaultSpawn.Z,
            Banned = false,
            BannedReason = 'Nothing',
            BannedTimestamp = '0000000000',
            Warns = 0,
            Cash = MoonStart.Cash,
            Bank = MoonStart.Bank,
            Muted = false,
            MuteTime = 0,
            MutedBy = 'No-one',
            WarnedBy = 'No-one',
            Jailed = false,
            JailTime = 0,
            JailedBy = 'No-one',
            Whitelisted = false
        }
        local PlayerMeta = {
            Hunger = 100,
            Thirst = 100,
            Shit = 0,
            Pee = 0
        }
        exports.oxmysql:execute('INSERT INTO accounts(user, license, data, metadata) VALUES (?, ?, ?, ?)', {GetPlayerName(src), Moon.GetLicense(src), json.encode(PlayerData), json.encode(PlayerMeta)})
        TriggerClientEvent('Moon:Client:Notification', src, 'Welcome to '..MoonServerName..', '..GetPlayerName(src)..'!', 'success')
        TriggerClientEvent('Moon:Client:LoadAccount', src, PlayerData, PlayerMeta)
    else
        if not Moon.CheckBanned(src) then
            local PlayerData = json.decode(result[1].data)
            local PlayerMeta = json.decode(result[1].metadata)
            TriggerClientEvent('Moon:Client:LoadAccount', src, PlayerData, PlayerMeta)
            TriggerClientEvent('Moon:Client:Notification', src, 'Welcome back, '..GetPlayerName(src)..'!', 'success')
            TriggerClientEvent("Moon:Client:Needs", src, PlayerMeta.hunger, PlayerMeta.thirst,PlayerMeta.pee, PlayerMeta.shit)
        else
            DropPlayer(src, 'You have been banned from this server.')
        end
    end
end

