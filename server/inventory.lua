---------------- Buy/Sell Item Functions ----------------

function Moon.BuyItem(source,type,item,amount)
    local license = Moon.GetLicense(source)
    if type == 'standard' then
        Moon.GiveItem(source, 'item_standard', item, 1)
        print('purchase successfully')
        TriggerClientEvent('hideStore', source)
    end
    if type == 'weapon' then
        Moon.GiveItem(source, 'weapon', item, 1)
        print('purchase successfully')
        TriggerClientEvent('hideStore', source)
    end
end


function Moon.SetItem(source,type,item,amount)
    local license = Moon.GetLicense(source)
    local item = Moon.Items[tostring(item)]
    local result = exports.oxmysql:fetchSync('SELECT * FROM inventories WHERE identifier = ? ', {license})
    if result[1] then
        local inv = json.decode(result[1].data)
        if inv.name == item.name then
            if inv.amount > 1 then
                local itemdata = {
                    name = item.name,
                    label = item.label,
                    amount = amount,
                    useable = item.useable,
                    removable = item.removable
                }
                exports.oxmysql:execute('UPDATE inventories SET data = ? WHERE identifier = ? AND type = ?', {json.encode(itemdata), license, type})
            end
        end
    end
end

----------------- Give/Remove Item Functions ------------------

function Moon.GiveItem(source,type,item,amount)
    local license = Moon.GetLicense(source)
    local item = Moon.Items[tostring(item)]
    
    local result = exports.oxmysql:fetchSync('SELECT * FROM inventories WHERE identifier = ? ', {license})
    
    if not result[1] then
        local itemdata = {
            name = item.name,
            label = item.label,
            amount = amount,
            useable = item.useable,
            removable = item.removable,
            img = item.img,
            weight = item.weight
        }
        exports.oxmysql:execute('INSERT INTO inventories(identifier, weight, type, data) VALUES (?, ?, ?, ?)', {license, 1, type, json.encode(itemdata)})
    elseif result[1] then
        local inv = json.decode(result[1].data)
        if inv.name == item.name then
            local itemdata = {
                name = item.name,
                label = item.label,
                amount = inv.amount + 1,
                useable = item.useable,
                removable = item.removable,
                img = item.img,
                weight = item.weight
            }
            exports.oxmysql:execute('UPDATE inventories SET weight = ? WHERE identifier = ? AND type = ?', {1, license, type})
            exports.oxmysql:execute('UPDATE inventories SET data = ? WHERE identifier = ? AND type = ?', {json.encode(itemdata), license, type})
        else
            local itemdata = {
                name = item.name,
                label = item.label,
                amount = amount,
                useable = item.useable,
                removable = item.removable,
                img = item.img,
                weight = item.weight
            }
            exports.oxmysql:execute('INSERT INTO inventories(identifier, weight, type, data) VALUES (?, ?, ?, ?)', {license, 1, type, json.encode(itemdata)})
        end
    end
end

function Moon.RemoveItemB(source,type,item,amount)
    local license = Moon.GetLicense(source)
    local item = Moon.Items[tostring(item)]
    local result = exports.oxmysql:fetchSync('SELECT * FROM inventories WHERE identifier = ? ', {license})
    if result[1] then
        local inv = json.decode(result[1].data)
        if inv.name == item.name then
            if inv.amount >= 2 then
                local itemdata = {
                    name = item.name,
                    label = item.label,
                    amount = inv.amount - 1,
                    useable = item.useable,
                    removable = item.removable
                }
                exports.oxmysql:execute('UPDATE inventories SET data = ? WHERE identifier = ? AND type = ?', {json.encode(itemdata), license, type})
            elseif inv.amount == 1 then
                 exports.oxmysql:execute('DELETE FROM inventories WHERE id = ?', {result[1].id})
            end
            
        end
    end
end

function Moon.RemoveItem(source,type,item,amount)
    local license = Moon.GetLicense(source)
    local item = Moon.Items[tostring(item)]
    local result = exports.oxmysql:fetchSync('SELECT * FROM inventories WHERE identifier = ? ', {license})
    if result[1] then
        local inv = json.decode(result[1].data)
        if inv.name == item.name then
            if inv.amount >= amount then
                local itemdata = {
                    name = item.name,
                    label = item.label,
                    amount = inv.amount - amount,
                    useable = item.useable,
                    removable = item.removable
                }
                exports.oxmysql:execute('UPDATE inventories SET data = ? WHERE identifier = ? AND type = ?', {json.encode(itemdata), license, type})
            elseif inv.amount == 1 then
                 exports.oxmysql:execute('DELETE FROM inventories WHERE id = ?', {result[1].id})
            elseif inv.amount == 0 then
                exports.oxmysql:execute('DELETE FROM inventories WHERE id = ?', {result[1].id})
            end
        end
    end
end

---------------------- Get Inventory ---------------------

Moon.GetInventoryItem = function(source, itemname)
    local result = exports.oxmysql:fetchSync('SELECT * FROM inventories WHERE identifier = ?', {Moon.GetLicense(source)})
    for k,v in pairs(result) do
        if json.decode(v.data).name == itemname then
            local itemname = json.decode(v.data).name
            local itemlabel = json.decode(v.data).label
            local itemamount = json.decode(v.data).amount
            local itemuseable = json.decode(v.data).useable
            local itemremovable = json.decode(v.data).removable
            local returncb = json.decode(v.data)
            return returncb
        end
    end
end

Moon.GetInventory = function(source)
    local result = exports.oxmysql:fetchSync('SELECT * FROM inventories WHERE identifier = ?', {Moon.GetLicense(source)})
   
    local inventory = json.decode(result[1].data) 
    
    return inventory
end

