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

function Moon.GetLicense(source)
    local license = ""
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(v, "license:") then
            license = v
            break
        end
    end
    return license
end

function Moon.GetPlayerId(source)
    local pID = 0
    local license = Moon.GetLicense(source)
    local id = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {license})
    if id[1] then
        pID = id[1].ID
        return pID
    else
        local name = GetPlayerName(source)
        local errCode = string.format("WARNING: Player %s [SERVER ID: %d] is not registered in your database! (0xC1)", name, source)
        print(errCode)
    end
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
Moon.GetPlayerData = function(source)
    local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {Moon.GetLicense(source)})
    local data = json.decode(result[1].data)
    return data
end

Moon.GetPlayerMeta = function(source)
    local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {Moon.GetLicense(source)})
    local meta = json.decode(result[1].metadata)
    return meta
end

Moon.SetPlayerMeta = function(source, meta, value)
    local src = source
    if meta == "hunger" then
        local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {Moon.GetLicense(source)})
        local newMeta = {
            Hunger = value,
            Thirst = json.decode(result[1].metadata).Thirst,
            Shit = json.decode(result[1].metadata).Shit,
            Pee = json.decode(result[1].metadata).Pee
        }
        exports.oxmysql:execute('UPDATE accounts SET metadata = ? WHERE license = ?', {json.encode(newMeta), Moon.GetLicense(source)})
        TriggerClientEvent("Moon:Client:Needs", src, newMeta.Hunger, newMeta.Thirst, newMeta.Pee, newMeta.Shit)
    elseif meta == 'thirst' then
        local result = exports.oxmysql:fetchSync('SELECT metadata FROM accounts WHERE license = ?', {Moon.GetLicense(source)})
        local newMeta = {
            Hunger = json.decode(result[1].metadata).Hunger,
            Thirst = value,
            Shit = json.decode(result[1].metadata).Shit,
            Pee = json.decode(result[1].metadata).Pee
        }
        exports.oxmysql:execute('UPDATE accounts SET metadata = ? WHERE license = ?', {json.encode(newMeta), Moon.GetLicense(source)})
        TriggerClientEvent("Moon:Client:Needs", src, newMeta.Hunger, newMeta.Thirst, newMeta.Pee, newMeta.Shit)
    elseif meta == 'pee' then
        local result = exports.oxmysql:fetchSync('SELECT metadata FROM accounts WHERE license = ?', {Moon.GetLicense(source)})
        local newMeta = {
            Hunger = json.decode(result[1].metadata).Hunger,
            Thirst = json.decode(result[1].metadata).Thirst,
            Shit = json.decode(result[1].metadata).Shit,
            Pee = value
        }
        exports.oxmysql:execute('UPDATE accounts SET metadata = ? WHERE license = ?', {json.encode(newMeta), Moon.GetLicense(source)})
        TriggerClientEvent("Moon:Client:Needs", src, newMeta.Hunger, newMeta.Thirst, newMeta.Pee, newMeta.Shit)
    elseif meta == 'shit' then
        local result = exports.oxmysql:fetchSync('SELECT metadata FROM accounts WHERE license = ?', {Moon.GetLicense(source)})
        local newMeta = {
            Hunger = json.decode(result[1].metadata).Hunger,
            Thirst = json.decode(result[1].metadata).Thirst,
            Shit = value,
            Pee = json.decode(result[1].metadata).Pee
        }
        exports.oxmysql:execute('UPDATE accounts SET metadata = ? WHERE license = ?', {json.encode(newMeta), Moon.GetLicense(source)})
        TriggerClientEvent("Moon:Client:Needs", src, newMeta.Hunger, newMeta.Thirst, newMeta.Pee, newMeta.Shit)
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
            X = Moon.DefaultSpawn.X,
            Y = Moon.DefaultSpawn.Y,
            Z = Moon.DefaultSpawn.Z,
            Banned = false,
            BannedReason = 'Nothing',
            BannedTimestamp = '0000000000',
            Warns = 0,
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

