Citizen.CreateThread(function()
  while true do
    Wait(1000)
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))
    TriggerServerEvent('checkforitemamount', plate)
  end  
end)
------------------ Animation Related Functions -----------------------

function Moon.RequestAnimSet(animSet, cb)
	if not HasAnimSetLoaded(animSet) then
		RequestAnimSet(animSet)

		while not HasAnimSetLoaded(animSet) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end


function Moon.RequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

------------------- Other Functions -----------------------
function Moon.Notification(type, text)
  local icon = ''
  local title = 'Notification'
  local message = text
  local time = 5000
  local da = MoonServerName
  if type == "error" then
      icon = 'fas fa-exclamation-circle text-danger'
      SendNUIMessage({
          action = 'open',
          sound = 'default',
          icon = icon,
          title = title,
          message = message,
          time = time,
          appname = da
      })
  elseif type == 'success' then
      icon = 'far fa-check-circle text-success'
      SendNUIMessage({
          action = 'open',
          sound = 'default',
          icon = icon,
          title = title,
          message = message,
          time = time,
          appname = da
      })
  elseif type == 'general' then
      icon = 'far fa-keyboard text-primary'
      SendNUIMessage({
          action = 'open',
          sound = 'default',
          icon = icon,
          title = title,
          message = message,
          time = time,
          appname = da
      })
  end
end


function Moon.TriggerCallback(name, cb, ...)
	Moon.ServerCallbacks[Moon.CurrentRequestId] = cb

	TriggerServerEvent('Moon:Server:TriggerCallback', name, Moon.CurrentRequestId, ...)

	if Moon.CurrentRequestId < 65535 then
		Moon.CurrentRequestId = Moon.CurrentRequestId + 1
	else
		Moon.CurrentRequestId = 0
	end
end

function Moon.GetPlayers()
  return GetActivePlayers()
end

Moon.GetPlayersInArea = function(coords, area)

    local players       = Moon.GetPlayers()
    local playersInArea = {}
  
    for i=1, #players, 1 do
  
      local target       = GetPlayerPed(players[i])
      local targetCoords = GetEntityCoords(target)
      local distance     = GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, targetCoords.z, coords.x, coords.y, coords.z, true)
  
      if distance <= area then
        table.insert(playersInArea, players[i])
      end
  
    end
  
    return playersInArea
  end

Moon.GetClosestPlayer = function(coords)

    local players         = Moon.GetPlayers()
    local closestDistance = -1
    local closestPlayer   = -1
    local coords          = coords
    local usePlayerPed    = false
    local playerPed       = GetPlayerPed(-1)
    local playerId        = PlayerId()
  
    if coords == nil then
      usePlayerPed = true
      coords       = GetEntityCoords(playerPed)
    end
  
    for i=1, #players, 1 do
  
      local target = GetPlayerPed(players[i])
  
      if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
  
        local targetCoords = GetEntityCoords(target)
        local distance     = GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, targetCoords.z, coords.x, coords.y, coords.z, true)
  
        if closestDistance == -1 or closestDistance > distance then
          closestPlayer   = players[i]
          closestDistance = distance
        end
  
      end
  
    end
  
    return closestPlayer, closestDistance
  end

Moon.MathTrim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end
