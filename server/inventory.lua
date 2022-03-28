
function Moon.GiveItem(source,type,item,amount)
    local license = Moon.GetLicense(source)
    local item = Moon.Items[tostring(item)]
    local existingitems = exports.oxmysql:fetchSync('SELECT * FROM inventories WHERE identifier = ? ', {license})
    if item then
        if existingitems then
            if existingitems[1].itemname == item.name then
                local itemdata = {
                    itemamount = existingitems[1].itemamount + amount
                }
                exports.oxmysql:execute('UPDATE inventories SET data = ? WHERE identifier = ? AND type = ?', {json.encode(itemdata)}, license, type)
            else
                local itemdata = {
                    itemname = item.name,
                    itemlabel = item.label,
                    itemdescription = item.description,
                    itemamount = amount
                }
                exports.oxmysql:execute('INSERT INTO inventories(identifier, type, data) VALUES (?, ?, ?, ?)', {license, type, json.encode(itemdata)})
            end
        else
            local itemdata = {
                itemname = item.name,
                itemlabel = item.label,
                itemdescription = item.description,
                itemamount = amount
            }
            exports.oxmysql:execute('INSERT INTO inventories(identifier, type, data) VALUES (?, ?, ?, ?)', {license, type, json.encode(itemdata)})
        end
    else
        local errCode = string.format("WARNING: ITEM %s does not exist!", item)
        print(errCode)
    end
end

function Moon.RemoveItem(source,type,item,amount)
    local license = Moon.GetLicense(source)
    local item = Moon.Items[tostring(item)]
    local existingitems = exports.oxmysql:fetchSync('SELECT * FROM inventories WHERE identifier = ? ', {license})
    if item then
        if existingitems then
            if existingitems[1].itemname == item.name then
                local newamount = existingitems[1].itemamount - amount
                if newamount <= 0 then
                    exports.oxmysql:execute('DELETE FROM inventories WHERE identifier = ? AND type AND data = ?', {license, type, json.encode(itemdata)})
                else
                    local itemdata = {
                        itemamount = newamount
                    }
                    exports.oxmysql:execute('UPDATE inventories SET data = ? WHERE identifier = ? AND type = ?', {json.encode(itemdata)}, license, type)
                end
            
                exports.oxmysql:execute('INSERT INTO inventories(identifier, type, data) VALUES (?, ?, ?, ?)', {license, type, json.encode(itemdata)})
            else
                local errCode = string.format("WARNING: Player does not have ITEM %s !", item)
                print(errCode)
            end
        else
            local errCode = string.format("WARNING: Player does not have ITEM %s !", item)
            print(errCode)
        end
    else
        local errCode = string.format("WARNING: ITEM %s does not exist!", item)
        print(errCode)
    end
end