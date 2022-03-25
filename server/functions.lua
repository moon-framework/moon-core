
MoonClient = function(protectedByRaisen, c, ...)
    local args = ...
    if GetPlayerName(c) == nil then return end
    TriggerClientEvent(protectedByRaisen, c, args)
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
