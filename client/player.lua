PlayerData = {}
PlayerMetaData = {}

RegisterNetEvent('MClient:GetPlayerData', function(data, metadata)
    PlayerData = data
    PlayerMetadata = metadata
end)