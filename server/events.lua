RegisterServerEvent('Moon:Server:PlayerJoined')
AddEventHandler('Moon:Server:PlayerJoined', function()
    local license = Moon.GetLicense(source)
    local pName = GetPlayerName(source)
    local result = exports.oxmysql:fetchSync('SELECT * FROM accounts WHERE license = ?', {license})
    if result[1] then
        print('account found')
    else
        print('create account')
        local accountData = {
            name = pName,
            license = license
        }
        local uData = {

            firstname = 'Unset',
            lastname = 'Unset',
            gender = 'Unset',
            age = 'Unset',
            adminLevel = 0

        }
        
        exports.oxmysql:execute('INSERT INTO accounts(user, license, data) VALUES (?, ?, ?)', {accountData.name, accountData.license, json.encode(uData)})

    end
end)