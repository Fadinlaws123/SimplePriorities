if Config.Peacetime.FrameworkSettings.Framework == 'nd' then 
  NDCore = exports["ND_Core"]:GetCoreObject()
end
local countyPrioText = ""
local cityPrioText = ""
local visible = true

TriggerEvent('chat:addSuggestion', Config.Priorities.County_Priority.Commands.StartPrio, 'Start a priority in the' .. Config.Priorities.County_Priority.TextSettings.ZoneName .. '!')
TriggerEvent('chat:addSuggestion', Config.Priorities.County_Priority.Commands.PrioEnd, 'End the ongoing priority in the ' .. Config.Priorities.County_Priority.TextSettings.ZoneName .. '!')
TriggerEvent('chat:addSuggestion', Config.Priorities.County_Priority.Commands.JoinPrio, 'Join an ongoing priority in the ' .. Config.Priorities.County_Priority.TextSettings.ZoneName .. '!')
TriggerEvent('chat:addSuggestion', Config.Priorities.County_Priority.Commands.LeavePrio, 'Leave the ongoing priority in the ' .. Config.Priorities.County_Priority.TextSettings.ZoneName .. '!')
TriggerEvent('chat:addSuggestion', Config.Priorities.County_Priority.Commands.PrioCooldown, 'Place ' .. Config.Priorities.County_Priority.TextSettings.ZoneName .. ' priorities on cooldown', {
  { name = "Time", help = "Time in minutes that priority cooldown will be enabled for!"}
})
TriggerEvent('chat:addSuggestion', Config.Priorities.County_Priority.Commands.PrioOnHold, 'Put ' .. Config.Priorities.County_Priority.TextSettings.ZoneName .. ' priorities on hold.')
TriggerEvent('chat:addSuggestion', Config.Priorities.County_Priority.Commands.PrioAvailable, 'Reset the ' .. Config.Priorities.County_Priority.TextSettings.ZoneName .. ' priority system.')

TriggerEvent('chat:addSuggestion', Config.Priorities.City_Priority.Commands.StartPrio, 'Start a priority in the ' .. Config.Priorities.City_Priority.TextSettings.ZoneName .. '!')
TriggerEvent('chat:addSuggestion', Config.Priorities.City_Priority.Commands.PrioEnd, 'End the ongoing priority in the ' .. Config.Priorities.City_Priority.TextSettings.ZoneName .. '!')
TriggerEvent('chat:addSuggestion', Config.Priorities.City_Priority.Commands.JoinPrio, 'Join an ongoing priority in the ' .. Config.Priorities.City_Priority.TextSettings.ZoneName .. '!')
TriggerEvent('chat:addSuggestion', Config.Priorities.City_Priority.Commands.LeavePrio, 'Leave the ongoing priority in the ' .. Config.Priorities.City_Priority.TextSettings.ZoneName .. '!')
TriggerEvent('chat:addSuggestion', Config.Priorities.City_Priority.Commands.PrioCooldown, 'Place ' .. Config.Priorities.City_Priority.TextSettings.ZoneName .. ' priorities on cooldown', {
  { name = "Time", help = "Time in minutes that priority cooldown will be enabled for!"}
})
TriggerEvent('chat:addSuggestion', Config.Priorities.City_Priority.Commands.PrioOnHold, 'Put ' .. Config.Priorities.City_Priority.TextSettings.ZoneName .. ' priorities on hold.')
TriggerEvent('chat:addSuggestion', Config.Priorities.City_Priority.Commands.PrioAvailable, 'Reset the ' .. Config.Priorities.City_Priority.TextSettings.ZoneName .. ' priority system.')


RegisterNetEvent('SimplePrio:County:ReturnPrio')
AddEventHandler('SimplePrio:County:ReturnPrio', function(countyPrio)
  countyPrioText = countyPrio
end)

RegisterNetEvent('SimplePrio:City:ReturnPrio')
AddEventHandler('SimplePrio:City:ReturnPrio', function(cityPrio)
  cityPrioText = cityPrio
end)

AddEventHandler('playerSpawned', function()
  TriggerServerEvent('SimplePrio:getPrio')
end)

AddEventHandler('onResourceStart', function(resourceName)
  Wait(3000)
  TriggerServerEvent('SimplePrio:getPrio')
end)

-- Framework Permission Checking --
local isCop = false
local peacetimeon = false
local peacetimestatus = '~r~Disabled~w~'

if Config.Peacetime.FrameworkSettings.Framework == 'nat' then 
  Citizen.CreateThread(function()
    if NetworkIsSessionStarted() then
      TriggerServerEvent('SimplePrio:GetPermissions')
    end
  end)

  RegisterNetEvent('SimplePrio:RefreshPermissions')
  AddEventHandler('SimplePrio:RefreshPermissions', function()
    isCop = true
  end)

  Citizen.CreateThread(function()
    while true do 
      Citizen.Wait(0)
      if isCop then
        return 
      else
        DisableControls()
      end
    end
  end)
elseif Config.Peacetime.FrameworkSettings.Framework == 'nd' then 
  function NDCoreLEO()
    local job = NDCore.Functions.GetSelectedCharacters().job
    for _, department in pairs(Config.Peacetime.FrameworkSettings.DepartmentInfo.ND_Core_Framework) do
      if department == job then
        return true
      end
    end
    return false
  end

  Citizen.CreateThread(function()
    while true do 
      Citizen.Wait(0)
      if NDCoreLEO then
        return 
      else
        DisableControls()
      end
    end
  end)
end

AddEventHandler('onClientMapStart', function()
  TriggerServerEvent('SimplePrio:peacetime:Sync')
end)

RegisterNetEvent('SimplePrio:peacetime')
AddEventHandler('SimplePrio:peacetime', function(NewPeacetimestatus)
  peacetimeon = NewPeacetimestatus
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if peacetimeon == false then
      peacetimestatus = '~r~Disabled'
    else
      peacetimestatus = '~g~Enabled'
      if Config.Peacetime.FrameworkSettings.Framework == 'standalone' then
        DisableControls()
      end
    end
  end
end)

RegisterNetEvent('SimplePrio:CheckJob')
AddEventHandler('SimplePrio:CheckJob', function()
  if Config.Peacetime.FrameworkSettings.Framework == 'nd' then
    NDCoreLEO()
  elseif Config.Peacetime.FrameworkSettings.Framework == 'nat' then
    TriggerServerEvent('SimplePrio:GetPermissions', -1)
  end
end)

function DisableControls()
  DisablePlayerFiring(ped, true)
  DisableControlAction(0, 24, true)
  DisableControlAction(0, 25, true)
  DisableControlAction(0, 47, true)
  DisableControlAction(0, 58, true)
  DisableControlAction(1, 37, true)
  DisableControlAction(0, 140, true)
  DisableControlAction(0, 141, true)
  DisableControlAction(0, 142, true)
  DisableControlAction(0, 143, true)
  DisableControlAction(0, 263, true)
  DisableControlAction(0, 264, true)
  DisableControlAction(0, 257, true)
end


-- HUD Drawing --

function DrawHUD()
  Citizen.CreateThread(function()
    while visible do
        -- Serverwide Peacetime HUD --
        text(Config.Peacetime.DisplaySettings.Prefix, Config.Peacetime.DisplaySettings.Prefix_Location.x_location, Config.Peacetime.DisplaySettings.Prefix_Location.y_location, Config.Peacetime.DisplaySettings.Prefix_Location.TextScale, 4)
        text(peacetimestatus, Config.Peacetime.DisplaySettings.StatusMessage_Location.x_location, Config.Peacetime.DisplaySettings.StatusMessage_Location.y_location, Config.Peacetime.DisplaySettings.StatusMessage_Location.TextScale, 4)
        -- County Priority HUD --
        text(Config.Priorities.County_Priority.TextSettings.StatusMessages.Prefix, Config.Priorities.County_Priority.DisplaySettings.Prefix_Location.x_location, Config.Priorities.County_Priority.DisplaySettings.Prefix_Location.y_location, Config.Priorities.County_Priority.DisplaySettings.Prefix_Location.TextScale, 4)
        text(countyPrioText, Config.Priorities.County_Priority.DisplaySettings.StatusMessage_Location.x_location, Config.Priorities.County_Priority.DisplaySettings.StatusMessage_Location.y_location, Config.Priorities.County_Priority.DisplaySettings.StatusMessage_Location.TextScale, 4)
        -- City Priority HUD --
        text(Config.Priorities.City_Priority.TextSettings.StatusMessages.Prefix, Config.Priorities.City_Priority.DisplaySettings.Prefix_Location.x_location, Config.Priorities.City_Priority.DisplaySettings.Prefix_Location.y_location, Config.Priorities.City_Priority.DisplaySettings.Prefix_Location.TextScale, 4)
        text(cityPrioText, Config.Priorities.City_Priority.DisplaySettings.StatusMessage_Location.x_location, Config.Priorities.City_Priority.DisplaySettings.StatusMessage_Location.y_location, Config.Priorities.City_Priority.DisplaySettings.StatusMessage_Location.TextScale, 4)
        Citizen.Wait(0)
      end
      TerminateThisThread()
  end)
end

DrawHUD()

RegisterCommand(Config.Priorities.PriorityHUD, function()
    visible = not visible
    DrawHUD()
    TriggerEvent('chatMessage', "~w~[~b~SimplePrio~w~] ~o~Priority HUD has been toggled!")
end)

function text(text, x, y, scale, font)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextOutline()
  SetTextJustification(1)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x, y)
end