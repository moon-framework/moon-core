----------------- Useable Item Functions -----------------

function Moon.Functions.CreateUseableItem(item, cb)
    Moon.UseableItems[item] = cb
end

function Moon.Functions.CanUseItem(item)
    return Moon.UseableItems[item]
end

function Moon.Functions.UseItem(source, item)
    local src = source
    Moon.UseableItems[item](src, item)
end

----------------- Created Usable Items --------------------

Moon.Functions.CreateUseableItem('apple', function(source, item)
    
    print(Moon.GetLicense(source))
    Moon.RemoveItem(source, 'item_standard', 'apple', 1)

end)

Moon.Functions.CreateUseableItem('storeapple', function(source, item)
    
    print(Moon.GetLicense(source))
    local result = exports.oxmysql:fetchSync("SELECT * FROM shops WHERE type = ?", {"store"})
    local shop = json.decode(result[1].data)
    local cost = 0
    if item == shop.name then
        cost = shop.amount
    end
    Moon.BuyItem(source, 'item_standard', 'apple', cost)
    TriggerClientEvent('hideStore', source)
end)

Moon.Functions.CreateUseableItem('storepistol', function(source, item)
    
    print(Moon.GetLicense(source))
    local result = exports.oxmysql:fetchSync("SELECT * FROM shops WHERE type = ?", {"store"})
    local shop = json.decode(result[1].data)
    local cost = 0
    if item == shop.name then
        cost = shop.amount
    end
    Moon.BuyItem(source, 'item_standard', 'pistol', cost)
    TriggerClientEvent('hideStore', source)
end)