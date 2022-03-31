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

function Moon.GetPlayerSource(id)
    local sid = exports.oxmysql:fetchSync('SELECT SS FROM accounts WHERE license = ?', {Moon.GetLicense(tonumber(id))})
    return tonumber(sid)
end

function Moon.AssignSID(source)
    exports.oxmysql:execute('UPDATE accounts SET server-source = ? WHERE license = ?', {source, Moon.GetLicense(source)})
end

----------------- Player Info -------------------------

Moon.GetMoney = function(source, type)
    local money = 0
    if type == 'cash' then
        money = Moon.GetPlayerData(source).cash
    end
    if type == 'bank' then
        money = Moon.GetPlayerData(source).bank
    end
    return money
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

Moon.SavePlayer = function(source, pData, pMeta)
    exports.oxmysql:execute('UPDATE accounts SET data = ? WHERE license = ?', {json.encode(pData), Moon.GetLicense(source)})
    exports.oxmysql:execute('UPDATE accounts SET metadata = ? WHERE license = ?', {json.encode(pMeta), Moon.GetLicense(source)})
end

Moon.SetPlayerMeta = function(source, meta, value)
    local src = source
    local PlayerMeta = Moon.GetPlayerMeta(source)
    if meta:lower() == "hunger" then
        PlayerMeta.Hunger = value
        TriggerClientEvent("Moon:Client:Needs", src, newMeta.Hunger, newMeta.Thirst, newMeta.Pee, newMeta.Shit)
    elseif meta:lower() == 'thirst' then
        PlayerMeta.Thirst = value
        TriggerClientEvent("Moon:Client:Needs", src, newMeta.Hunger, newMeta.Thirst, newMeta.Pee, newMeta.Shit)
    elseif meta:lower() == 'pee' then
        PlayerMeta.Pee = value
        TriggerClientEvent("Moon:Client:Needs", src, newMeta.Hunger, newMeta.Thirst, newMeta.Pee, newMeta.Shit)
    elseif meta:lower() == 'shit' then
        PlayerMeta.Shit = value
        TriggerClientEvent("Moon:Client:Needs", src, newMeta.Hunger, newMeta.Thirst, newMeta.Pee, newMeta.Shit)
    end
    Moon.SavePlayer(source)
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