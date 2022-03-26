RegisterServerEvent('MServer:PlayerJoined')
AddEventHandler('MServer:PlayerJoined', function()
    local src = source
    local license = Moon.GetLicense(src)
    local pName = GetPlayerName(src)
    local uData = {}
    local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {license})
    if result[1] then
        uData = {
            x = json.decode(result[1].data).x,
            y = json.decode(result[1].data).y,
            z = json.decode(result[1].data).z
        }
        MoonClient('MClient:PlayerLoaded', src, uData)
    else
        local accountData = {
            name = pName,
            license = license
        }
        uData = {
            firstname = 'Unset',
            lastname = 'Unset',
            gender = 'Unset',
            age = 'Unset',
            adminLevel = 0,
            new = 0,
            x = Moon.Spawn.x,
            y = Moon.Spawn.y,
            z = Moon.Spawn.z,
            h = 0
        }
        exports.oxmysql:execute('INSERT INTO accounts(user, license, data) VALUES (?, ?, ?)', {accountData.name, accountData.license, json.encode(uData)})
    end
    MoonClient('MClient:PlayerLoaded', src, uData)
end)

RegisterServerEvent('printCoords')
AddEventHandler('printCoords', function(coords)
    print(coords)
end)

RegisterServerEvent('MServer:PlayerUnload')
AddEventHandler('MServer:PlayerUnload', function(data)
    local license = Moon.GetLicense(src)
    local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {license})
    local uData = {
        firstname = json.decode(result[1].data).firstname,
        lastname = json.decode(result[1].data).lastname,
        gender = json.decode(result[1].data).gender,
        age = json.decode(result[1].data).age,
        adminLevel = json.decode(result[1].data).adminLevel,
        new = json.decode(result[1].data).new,
        x = data.x,
        y = data.y,
        z = data.z,
        h = 0
    }
    exports.oxmysql:execute('UPDATE accounts SET data = ? WHERE license = ?', {data, license})
end)