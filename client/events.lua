PlayerData = {}
PlayerMeta = {}

---------------------- Account Loading -----------------------
------ DO NOT TOUCH UNLESS YOU KNOW WHAT YOU'RE DOING --------

AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent('Moon:Server:CheckAccount')
    TriggerServerEvent('Moon:Server:AssignSID')
end)

Citizen.CreateThread(function()
    TriggerServerEvent('Moon:Server:CheckAccount') -- debugging+
end)
 
local function setModel(_model)
    local model = _model
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        if model ~= "mp_f_freemode_01" and model ~= "mp_m_freemode_01" then 
            SetPedRandomComponentVariation(PlayerPedId(), true)
        else
            SetPedComponentVariation(PlayerPedId(), 11, 0, 240, 0)
            SetPedComponentVariation(PlayerPedId(), 8, 0, 240, 0)
            SetPedComponentVariation(PlayerPedId(), 11, 6, 1, 0)
        end
        SetModelAsNoLongerNeeded(model)
    end
end

RegisterNetEvent('Moon:Client:LoadAccount', function(pData, pMeta)
    PlayerData = pData
    PlayerMeta = pMeta
    setModel('mp_m_freemode_01')
    SetEntityCoords(PlayerPedId(), PlayerData.X, PlayerData.Y, PlayerData.Z)
end)

-------------------- Call Backs ---------------------------

RegisterNetEvent('moon:serverCallback')
AddEventHandler('moon:serverCallback', function(requestId, ...)
	Moon.ServerCallbacks[requestId](...)
	Moon.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('Moon:Client:TriggerCallback', function(name, ...)
    if Moon.Callbacks[name] then
        Moon.Callbacks[name](...)
        Moon.Callbacks[name] = nil
    end
end)

-------------------- Other Events ---------------------------

RegisterNetEvent('Moon:Client:UseItem', function(item)
    TriggerServerEvent('Moon:Server:UseItem', item)
end)

RegisterNetEvent('Moon:Client:Notification')
AddEventHandler('Moon:Client:Notification', function(text, type)
	Moon.Notification(type, text)
end)