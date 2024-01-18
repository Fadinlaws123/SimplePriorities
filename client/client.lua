if Config.Peacetime.Basic.Framework == 'nd' then
  NDCore = exports["ND_Core"]:GetCoreObject()
end
local countyprio = Config.CountyPriority.Basic.DefaultStatus
local cityprio = Config.CityPriority.Basic.DefaultStatus
local synced = false
local visible = true
local peacetimeon = false
local peacetimestatus = '~r~Disabled~w~'
local isCop = false

Citizen.CreateThread(function()
  TriggerEvent('chat:addSuggestion', '/county-pstart', 'Activate a priority for the ' .. Config.CountyPriority.Basic.ZoneName)
  TriggerEvent('chat:addSuggestion', '/county-pavail', 'Reset the priority for the county to be available again!')
  TriggerEvent('chat:addSuggestion', '/county-pcd', 'Enabled priority cooldown for the county!')
  TriggerEvent('chat:addSuggestion', '/county-phold', 'Put all priorities on hold for the county!')

  TriggerEvent('chat:addSuggestion', '/city-pstart', 'Activate a priority for the ' .. Config.CityPriority.Basic.ZoneName)
  TriggerEvent('chat:addSuggestion', '/city-pavail', 'Reset the priority for the county to be available again!')
  TriggerEvent('chat:addSuggestion', '/city-pcd', 'Enabled priority cooldown for the county!')
  TriggerEvent('chat:addSuggestion', '/city-phold', 'Put all priorities on hold for the county!')

  TriggerEvent('chat:addSuggestion', '/pt', 'Enable / Disable state-wide peacetime!')
    if not synced then
        if NetworkIsSessionStarted() then
            TriggerServerEvent('SimplePrio:RequestSync')
            synced = true
        end
    end
end)

if Config.Peacetime.Basic.Framework == "nd" then
  function NDCoreLEO()
    local job = NDCore.Functions.GetSelectedCharacter().job
    for _, department in pairs(Config.Peacetime.NDCore_Departments) do
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

elseif Config.Peacetime.Basic.Framework == "nat" then
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
end


RegisterNetEvent('Client:Sync')
AddEventHandler('Client:Sync', function(type, update)
  if type == 'countyprio' then
    countyprio = update
  else 
    cityprio = update
  end
end)

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
      if Config.Peacetime.Basic.Framework == 'standalone' then
        DisableControls()
      end
    end
  end
end)

RegisterNetEvent("SimplePrio:CheckJob")
AddEventHandler("SimplePrio:CheckJob", function()
  if Config.Peacetime.Basic.Framework == "nd" then
    NDCoreLEO()
  elseif Config.Peacetime.Basic.Framework == "nat" then
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

function DrawHud()
  Citizen.CreateThread(function()
      while visible do
          Draw(Config.CountyPriority.Text.Prefix .. '' .. countyprio, Config.CountyPriority.Basic.Display_X, Config.CountyPriority.Basic.Display_Y, Config.CountyPriority.Basic.Scale, 4)
          Draw(Config.CityPriority.Text.Prefix .. '' .. cityprio, Config.CityPriority.Basic.Display_X, Config.CityPriority.Basic.Display_Y, Config.CityPriority.Basic.Scale, 4)
          Draw(Config.Peacetime.Text.Prefix .. '' .. peacetimestatus, Config.Peacetime.Basic.Display_X, Config.Peacetime.Basic.Display_Y, Config.Peacetime.Basic.Scale, 4)
          Citizen.Wait(0)
      end
      TerminateThisThread()
  end)
end

DrawHud()

RegisterCommand(Config.ToggleVisibility, function()
  visible = not visible
  DrawHud()
  TriggerEvent('chatMessage', '^3SimplePrio^0: Prio HUD toggled.')
end)

function Draw(text, x, y, scale, font)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextOutline()
  SetTextJustification(1)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x, y)
end
