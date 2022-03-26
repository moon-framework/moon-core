PlayerData = {}
PlayerMetaData = {}

function Moon.GetPlayerData(source)
    local src = source
    local license = Moon.GetLicense(src)
    local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {license})
    local pData = json.decode(result[1].data)
    return pData;
end
function Moon.GetPlayerMeta(source)
    local src = source
    local license = Moon.GetLicense(src)
    local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {license})
    local mData = json.decode(result[1].metadata)
    return mData;
end
RegisterServerEvent('MServer:PlayerLoaded')
AddEventHandler('MServer:PlayerLoaded', function()
    local src = source
    PlayerData = Moon.GetPlayerData(src)
    PlayerMetaData = Moon.GetPlayerMeta(src)
    TriggerClientEvent('MClient:GetPlayerData', src, PlayerData, PlayerMetaData)
end)
