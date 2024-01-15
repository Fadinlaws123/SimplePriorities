local countyprio = Config.CountyPriority.Basic.DefaultStatus
local cityprio = Config.CityPriority.Basic.DefaultStatus
local countyprioCooldown = false
local countyprioActive = false
local cityprioCooldown = false
local countyonHold = false
local cityprioActive = false
local cityonHold = false
local countycooldown = 0
local citycooldown = 0

RegisterNetEvent('SimplePrio:RequestSync')
AddEventHandler('SimplePrio:RequestSync', function()
  local src = source 
  TriggerClientEvent('Client:Sync', src, 'countyprio', countyprio)
  TriggerClientEvent('Client:Sync', src, 'cityprio', cityprio)
end)

function CountyCooldown()
  if countycooldown ~= 0 then
    countyprioCooldown = true
    countyprioActive = false
    while countycooldown > 0 do 
      countyprio = Config.CountyPriority.Text.CooldownText .. ' (' .. countycooldown .. ' Minutes remaining!)'
      TriggerClientEvent('Client:Sync', -1, 'countyprio', countyprio)
      countycooldown = countycooldown - 1;
      Citizen.Wait(60 * 1000)
    end
  end
  if countycooldown <= 0 then
    countyprio = Config.CountyPriority.Text.AvailableText
    TriggerClientEvent('Client:Sync', -1, 'countyprio', countyprio)
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~NOTICE: ~y~Cooldown timer expired! Priorities are available again!"}
    })
    countyprioCooldown = false
    countyprioActive = false
  end
end

function CityCooldown()
  cityprioCooldown = true
  cityprioActive = false
  if citycooldown ~= 0 then
    while citycooldown > 0 do 
      cityprio = Config.CityPriority.Text.CooldownText .. ' (' .. citycooldown .. ' Minutes remaining!)'
      TriggerClientEvent('Client:Sync', -1, 'cityprio', cityprio)
      citycooldown = citycooldown - 1;
      Citizen.Wait(60 * 1000)
    end
  end
  if citycooldown == 0 then
    cityprio = Config.CityPriority.Text.AvailableText
    TriggerClientEvent('Client:Sync', -1, 'cityprio', cityprio)
    cityprioCooldown = true
    cityprioActive = false
  end
end
    

-- County Priority System --

RegisterCommand('county-phold', function(source, args, rawCommand)
  if IsPlayerAceAllowed(source, 'prio.admin') then
    countyprio = Config.CountyPriority.Text.HoldText
    TriggerClientEvent('Client:Sync', -1, 'countyprio', countyprio)
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~NOTICE: ~y~All county-wide priorities have been placed ON HOLD! Passive RP Until further notice!"}
    })
    countyonHold = true
  else
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "You lack permissions to use this command!"}
    })
  end
end)

RegisterCommand('county-pavail', function(source, args, rawCommand)
  if IsPlayerAceAllowed(source, 'prio.admin') then 
    if countyprioCooldown == true then
      countyprio = Config.CountyPriority.Text.AvailableText
      TriggerClientEvent('Client:Sync', -1, 'countyprio', countyprio)
      countycooldown = 0 
      countyprioCooldown = false
      TriggerClientEvent("chat:addMessage", source, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~b~SimplePrio", "~r~ERROR: ~y~Please wait for the county cooldown to end before changing it to available!"}
      })
    elseif countyprioActive == true then
      countyprioActive = false
      TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~b~SimplePrio", "~r~NOTICE: ~y~County Priority has been set to available by " .. GetPlayerName(source) .. '!'}
      })
      countyprio = Config.CountyPriority.Text.AvailableText
      TriggerClientEvent('Client:Sync', -1, 'countyprio', countyprio)
    else
      if countyonHold == true then
        TriggerClientEvent("chat:addMessage", -1, {
          color = {255, 0, 0},
          multiline = true,
          args = {"~b~SimplePrio", "~r~NOTICE: ~y~County Priorities was set to be available by " .. GetPlayerName(source) .. "! You are free to start priorities!"}
        })
        countyprio = Config.CountyPriority.Text.AvailableText
        TriggerClientEvent('Client:Sync', -1, 'countyprio', countyprio)
        countyonHold = false
      end
    end
  else
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "You lack permissions to use this command!"}
    })
  end
end)

RegisterCommand('county-pstart', function(source, args, rawCommand)
  if countyprioCooldown then
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~ERROR: ~y~Please wait for the cooldown to end before activating a priority!"}
    })
    return
  end
  if countyprioActive then
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~ERROR: ~y~There is already a priority active! Please wait!"}
    })
    return
  end
  if countyonHold then
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~ERROR: ~y~All county priorities are currently on hold!"}
    })
    return
  end
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~NOTICE: ~y~A priority has been started by " .. GetPlayerName(source) .. ' in the ' .. Config.CountyPriority.Basic.ZoneName .. '!'}
    })
    countyprio = Config.CountyPriority.Text.ActiveText .. ' (' .. GetPlayerName(source) .. ' | ID:' .. source .. ')'
    TriggerClientEvent('Client:Sync', -1, 'countyprio', countyprio)
    countyprioActive = true
end)

RegisterCommand('county-pcd', function(source, args, rawCommand)
  TriggerClientEvent("chat:addMessage", -1, {
    color = {255, 0, 0},
    multiline = true,
    args = {"~b~SimplePrio", "~r~NOTICE: ~y~The priority was ended by " .. GetPlayerName(source) .. '! Cooldown is now in effect!'}
  })
    countycooldown = Config.CountyPriority.Basic.CooldownTimer
    CountyCooldown()
end)

-- City Priority System --

RegisterCommand('city-phold', function(source, args, rawCommand)
  if IsPlayerAceAllowed(source, 'prio.admin') then 
    cityprio = Config.CityPriority.Text.HoldText
    TriggerClientEvent('Client:Sync', -1, 'countyprio', countyprio)
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~NOTICE: ~y~All city-wide priorities have been placed ON HOLD! Passive RP Until further notice!"}
    })
    cityonHold = true
  else 
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "You lack permissions to use this command!"}
    })
  end
end)

RegisterCommand('city-pavail', function(source, args, rawCommand)
  if IsPlayerAceAllowed(source, 'prio.admin') then 
    if cityprioCooldown == true then
      TriggerClientEvent('Client:Sync', -1, 'cityprio', cityprio)
      TriggerClientEvent("chat:addMessage", source, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~b~SimplePrio", "~r~ERROR: ~y~Please wait for the city cooldown to end before changing it to available!"}
      })
    elseif cityprioActive == true then
      cityprioActive = false
      TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~b~SimplePrio", "~r~NOTICE: ~y~City Priority has been set to available by " .. GetPlayerName(source) .. '!'}
      })
      cityprio = Config.CityPriority.Text.AvailableText
      TriggerClientEvent('Client:Sync', -1, 'cityprio', cityprio)
  
    else
      if cityonHold == true then
        TriggerClientEvent("chat:addMessage", -1, {
          color = {255, 0, 0},
          multiline = true,
          args = {"~b~SimplePrio", "~r~NOTICE: ~y~City Priorities was set to be available by " .. GetPlayerName(source) .. "! You are free to start priorities!"}
        })
        cityprio = Config.CityPriority.Text.AvailableText
        TriggerClientEvent('Client:Sync', -1, 'cityprio', cityprio)
        cityonHold = false
      end
    end
  else
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "You lack permissions to use this command!"}
    })
  end
end)

RegisterCommand('city-pstart', function(source, args, rawCommand)
  if cityprioCooldown then
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~ERROR: ~y~Please wait for the cooldown to end before activating a priority!"}
    })
    return
  end
  if cityprioActive then
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~ERROR: ~y~There is already a priority active! Please wait!"}
    })
    return
  end
  if cityonHold then
    TriggerClientEvent("chat:addMessage", source, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~ERROR: ~y~All city priorities are currently on hold!"}
    })
    return
  end
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~b~SimplePrio", "~r~NOTICE: ~y~A priority has been started by " .. GetPlayerName(source) .. ' in the ' .. Config.CityPriority.Basic.ZoneName .. '!'}
    })
    cityprio = Config.CityPriority.Text.ActiveText .. ' (' .. GetPlayerName(source) .. ' | ID:' .. source .. ')'
    TriggerClientEvent('Client:Sync', -1, 'cityprio', cityprio)
    cityprioActive = true
end)

RegisterCommand('city-pcd', function(source, args, rawCommand)
  TriggerClientEvent("chat:addMessage", -1, {
    color = {255, 0, 0},
    multiline = true,
    args = {"~b~SimplePrio", "~r~NOTICE: ~y~The City priority was ended by " .. GetPlayerName(source) .. '! Cooldown is now in effect!'}
  })
    citycooldown = Config.CityPriority.Basic.CooldownTimer
    CityCooldown()
end)

-- Peacetime System --

  peacetimeon = false

  RegisterServerEvent("SimplePrio:peacetime:Sync")
    AddEventHandler("SimplePrio:peacetime:Sync", function()
    TriggerClientEvent("SimplePrio:peacetime", -1, peacetimeon)
  end)

RegisterCommand('pt', function(source, args, rawCommand)
  local player = source
    if IsPlayerAceAllowed(source, 'pt.admin') then
      if peacetimeon then
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {"~b~SimplePrio", "Peacetime has been ~r~disabled~w~ by ~r~" .. GetPlayerName(source) .. "~w~!"}
        })
        peacetimeon = false
        TriggerEvent("SimplePrio:peacetime:Sync", peacetimeon)
      else 
        TriggerClientEvent("chat:addMessage", -1, {
          color = {255, 0, 0},
          multiline = true,
          args = {"~b~SimplePrio", "Peacetime has been ~g~enabled~w~ by ~r~" .. GetPlayerName(source) .. "~w~!"}
        })
        peacetimeon = true
        TriggerEvent("SimplePrio:peacetime:Sync", peacetimeon)
      end
    else
      TriggerClientEvent("chat:addMessage", source, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~b~SimplePrio", "You lack permissions to use this command!"}
      })
    end
end)
