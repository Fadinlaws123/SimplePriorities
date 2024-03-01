-- Grabs core systems from ND_Core if being used. --
if Config.Peacetime.FrameworkSettings.Framework == 'nd' then 
  NDCore = exports["ND_Core"]:GetCoreObject()
end

-- Peacetime Locals --
local timestamp = os.date("%c")
local isCop = false

-- County Priority Locals --
local countyPrio = Config.Priorities.City_Priority.TextSettings.DefaultStatus
local countyPrioCooldown = false
local countyPrioHold = false
local countyPrioActive = false
local countyPrioPlayers = {}
local countyCooldown = 0

-- City Priority Locals -- 
local cityPrio = Config.Priorities.City_Priority.TextSettings.DefaultStatus
local cityPrioCooldown = false
local cityPrioHold = false
local cityPrioActive = false
local cityPrioPlayers = {}
local cityCooldown = 0

--[[
   ---------------------------------------------------
  |                                                   |
  |                  Priority System                  |
  |                                                   |
   ---------------------------------------------------
]]

function tableConcat(table, concat)
  local string = ""
  local first = true
  for _, v in pairs(table) do
    if first then
      string = tostring(v)
      first = false
    else
      string = string .. concat .. tostring(v)
    end
  end
  return string
end

function tableCount(table)
  local count = 0
  for _ in pairs(table) do
    count = count + 1
  end
  return count
end

-- Priority Cooldown Function -- 

function countyCooldown(time)
  countyPrioActive = false
  countyPrioCooldown = true
  for countyCooldown = time, 1, -1 do
    if countyCooldown > 1 then
      countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusOnCooldown .. ' ~c~(~y~' .. countyCooldown .. '~c~ minutes)'
    else
      countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusOnCooldown .. ' ~c~(~y~' .. countyCooldown .. '~c~ minute)'
    end
    TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
    Citizen.Wait(60000)
  end
  countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusAvailable
  TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
  countyPrioCooldown = false
end

function cityCooldown(time)
  cityPrioActive = false
  cityPrioCooldown = true
  for cityCooldown = time, 1, -1 do
    if cityCooldown > 1 then
      cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusOnCooldown .. ' ~c~(~y~' .. cityCooldown .. '~c~ minutes)'
    else
      cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusOnCooldown .. ' ~c~(~y~' .. cityCooldown .. '~c~ minute)'
    end
    TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
    Citizen.Wait(60000)
  end
  cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusAvailable
  TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
  cityPrioCooldown = false
end

-- Prio Updating -- 

RegisterNetEvent('SimplePrio:getPrio')
AddEventHandler('SimplePrio:getPrio', function()
  local player = source
  TriggerClientEvent('SimplePrio:County:ReturnPrio', player, countyPrio)
  TriggerClientEvent('SimplePrio:City:ReturnPrio', player, cityPrio)
end)

-- Priority Start Function --

RegisterCommand(Config.Priorities.County_Priority.Commands.StartPrio, function(source, args, rawCommand)
  local player = source
  if countyPrioCooldown then
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You cannot start a priority due to cooldown!"}
    })
    CPrioStart_Fail('SimplePrio \n', '**→ County Priority Start Attempted by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *The countywide priority system is on cooldown!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.StartPrio .. '*')
    return
  elseif countyPrioHold then
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You cannot start a priority due to it being on hold!"}
    })
    CPrioStart_Fail('SimplePrio \n', '**→ County Priority Start Attempted by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *The countywide priority system is currently on hold!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.StartPrio .. '*')
    return
  elseif countyPrioActive then
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~]: ", "~r~ERROR: ~y~You cannot start a priority as one is already started!"}
      })
      CPrioStart_Fail('SimplePrio \n', '**→ County Priority Start Attempted by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There is already an active priority in the county!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.StartPrio .. '*')
    return
  else
    countyPrioActive = true
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~y~ALERT: ~r~A countywide priority has been ~g~started ~r~by ~o~" .. GetPlayerName(source) .. "~r~!"}
    })
    CPrioStart_Success('SimplePrio \n', '**→ County Priority Started by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True*\n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.StartPrio .. '*')
    countyPrioPlayers[player] = GetPlayerName(player) .. " #" .. player
    countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusActive .. ' ~c~(' .. tableConcat(countyPrioPlayers, ", ") .. ")"
    TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
  end
end, false)

-- Priority End Function -- 

RegisterCommand(Config.Priorities.County_Priority.Commands.PrioEnd, function(source, args, rawCommand)
  local player = source
  if not countyPrioActive then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~There is no priority that needs to be ended!"}
    })
    CPrioEnd_Fail('SimplePrio \n', '**→ County Priority End Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There wasn\'t an active priority to be ended!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioEnd .. '*')
    return
  end
  if Config.Priorities.County_Priority.TextSettings.CooldownSettings.CooldownTimer > 1 then
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~y~ALERT: ~r~A countywide priority has been ~r~ended ~r~by ~o~" .. GetPlayerName(source) .. "~r~! Cooldown is now in effect for " .. Config.Priorities.County_Priority.TextSettings.CooldownSettings.CooldownTimer .. ' minutes!'}
    })
  else
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~y~ALERT: ~r~A countywide priority has been ~r~ended ~r~by ~o~" .. GetPlayerName(source) .. "~r~! Cooldown is now in effect for " .. Config.Priorities.County_Priority.TextSettings.CooldownSettings.CooldownTimer .. ' minute!'}
    })
  end
  if countyPrioPlayers[player] then
    CPrioEnd_Success('SimplePrio \n', '**→ County Priority Ended by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True*\n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioEnd .. '*')
    countyPrioPlayers = {}
    countyCooldown(Config.Priorities.County_Priority.TextSettings.CooldownSettings.CooldownTimer)
  else
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~y~ALERT: ~r~You cannot end this priority as you are not apart of the priority!"}
    })
  end
end, false)

-- Priority Cooldown Function -- 

RegisterCommand(Config.Priorities.County_Priority.Commands.PrioCooldown, function(source, args, rawCommand)
  local player = source
  local time = tonumber(args[1])

  if countyPrioCooldown then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~y~There is already a county cooldown active! Please wait for the current cooldown to end before starting another cooldown!"}
    })
    CPrioCooldown_Fail('SimplePrio \n', '**→ County Priority Cooldown Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There is currently an active cooldown! You cannot have 2 cooldowns running!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioCooldown .. '*')
  else
    if IsPlayerAceAllowed(source, Config.Permissions.CooldownAcePermission) then 
      if time > 1 then
        TriggerClientEvent("chat:addMessage", -1, {
          color = {255, 0, 0},
          multiline = true,
          args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~y~A countywide priority cooldown has started by ~b~" .. GetPlayerName(source) .. "~y~ for ~r~" .. time .. ' minutes!'}
        })
      else
        TriggerClientEvent("chat:addMessage", -1, {
          color = {255, 0, 0},
          multiline = true,
          args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~y~A countywide priority cooldown has started by ~b~" .. GetPlayerName(source) .. "~y~ for ~r~" .. time .. ' minute!'}
        })
      end
      CPrioCooldown_Success('SimplePrio \n', '**→ County Priority Cooldown Started by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True* \n**→ Cooldown Timer:** *' .. time .. '*\n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioCooldown .. '*')
      if time and time > 0 then
        countyCooldown(time)
      end
    else
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You do not have permissions to use this command!"}
      })
      CPrioCooldown_Fail('SimplePrio \n', '**→ County Priority Cooldown Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *This user lacks permissions to use this command!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioCooldown .. '*')
    end
  end
end, false)

-- Priority Joining Function -- 

RegisterCommand(Config.Priorities.County_Priority.Commands.JoinPrio, function(source, args, rawCommand)
  local player = source
  if not countyPrioActive then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~There is not an active priority in the county that you can join!"}
    })
    CPrioJoin_Fail('SimplePrio \n', '**→ County Priority Join Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There is no active priority for this user to join!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.JoinPrio .. '*')
    return
  end
  if countyPrioPlayers[player] then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You are already apart of this priority!"}
    })
    return
  end
  CPrioJoin_Success('SimplePrio \n', '**→ County Priority Joined by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.JoinPrio .. '*')
  countyPrioPlayers[player] = GetPlayerName(player) .. ' #' .. player
  countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusActive .. ' ~c~(' .. tableConcat(countyPrioPlayers, ", ") .. ")"
  TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio) 
end, false)

-- Priority Leaving Function -- 

RegisterCommand(Config.Priorities.County_Priority.Commands.LeavePrio, function(source, args, rawCommand)
  local player = source
  if not countyPrioActive then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~There is not an active priority you can leave!"}
    })
    CPrioLeave_Fail('SimplePrio \n', '**→ County Priority Leave Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There is no active priority for you to leave!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.LeavePrio .. '*')
    return
  end
  if tableCount(countyPrioPlayers) == 1 and countyPrioPlayers[player] == GetPlayerName(player) .. ' #' .. player then
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~y~All players have left the active priority! Countywide Cooldown started automatically from ~b~SimplePrio~y~!"}
    })
    countyPrioPlayers = {}
    countyCooldown(Config.Priorities.County_Priority.TextSettings.CooldownSettings.CooldownTimer)
    countyPrioActive = false
  else
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~" .. GetPlayerName(source) .. ' ~y~has left the active county priority!'}
    })
    CPrioLeave_Success('SimplePrio \n', '**→ County Priority Left by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.LeavePrio .. '*')
    countyPrioPlayers[player] = nil
    countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusActive .. ' ~c~(' .. tableConcat(countyPrioPlayers, ", ") .. ")"
  end
  TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio) 
end, false)

-- Priority Reset Function -- 

RegisterCommand(Config.Priorities.County_Priority.Commands.PrioAvailable, function(source, args, rawCommand)
  local player = source
  if IsPlayerAceAllowed(source, Config.Permissions.ResetAcePermissions) then 
    if countyPrioActive then
      countyPrioPlayers = {}
      countyPrioActive = false
      countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusAvailable
    elseif countyPrioCooldown then
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~ You cannot reset the system as cooldown is ~g~enabled~b~! Please wait!"}
      })
    elseif countyPrioHold then
      countyPrioHold = false
      countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusAvailable
    else
      TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~" .. GetPlayerName(source) .. ' ~y~has reset the countywide priority system!'}
      })
      CPrioReset_Success('SimplePrio \n', '**→ County Priority System Reset by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioAvailable .. '*')
      TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio) 
    end
  else
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You lack the permissions requried to run this command!"}
    })
    CPrioReset_Fail('SimplePrio \n', '**→ County Priority System Reset by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n**→ Fail Details:** *This user lacks permissions to run this command!* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioAvailable .. '*')
  end
end, false)

-- Priority on Hold Function --

RegisterCommand(Config.Priorities.County_Priority.Commands.PrioOnHold, function(source, args, rawCommand)
  local player = source
  if IsPlayerAceAllowed(source, Config.Permissions.OnHoldAcePermission) then
    if countyPrioHold == true then
      countyPrioHold = false
      countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusAvailable
      TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~" .. GetPlayerName(source) .. ' ~y~has ~r~disabled~y~ county priorities being on hold!'}
      })
      CPrioHold_Disabled('SimplePrio \n', '**→ County Priority Hold Changed By: __' .. GetPlayerName(source) .. '__ \n ** **→ Hold Status: ** *Disabled* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioOnHold .. '*')
    else
      countyPrioHold = true
      countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages.StatusOnHold
      TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~" .. GetPlayerName(source) .. ' ~y~has ~g~enabled~y~ county priorities being on hold!'}
      })
      CPrioHold_Enabled('SimplePrio \n', '**→ County Priority Hold Changed By: __' .. GetPlayerName(source) .. '__ \n ** **→ Hold Status: ** *Enabled* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioOnHold .. '*')
    end
    TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio) 
  else
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You lack the permissions requried to run this command!"}
    })
    CPrioHold_Fail('SimplePrio \n', '**→ County Priority Hold Change Attempt By: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n**→ Fail Details:** *This user lacks permissions to run this command!* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.County_Priority.Commands.PrioOnHold .. '*')
  end
end, false)

-- City Priority System --

-- Priority Start Function --
RegisterCommand(Config.Priorities.City_Priority.Commands.StartPrio, function(source, args, rawCommand)
  local player = source
  if cityPrioCooldown then
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You cannot start a priority due to cooldown!"}
    })
    CityPrioStart_Fail('SimplePrio \n', '**→ City Priority Start Attempted by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *The citywide priority system is on cooldown!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.StartPrio .. '*')
    return
  elseif cityPrioHold then
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You cannot start a priority due to it being on hold!"}
    })
    CityPrioStart_Fail('SimplePrio \n', '**→ City Priority Start Attempted by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *The citywide priority system is currently on hold!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.StartPrio .. '*')
    return
  elseif cityPrioActive then
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~]: ", "~r~ERROR: ~y~You cannot start a priority as one is already started!"}
      })
      CityPrioStart_Fail('SimplePrio \n', '**→ City Priority Start Attempted by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There is already an active priority in the city!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.StartPrio .. '*')
    return
  else
    cityPrioActive = true
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~y~ALERT: ~r~A citywide priority has been ~g~started ~r~by ~o~" .. GetPlayerName(source) .. "~r~!"}
    })
    CityPrioStart_Success('SimplePrio \n', '**→ City Priority Started by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True*\n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.StartPrio .. '*')
    cityPrioPlayers[player] = GetPlayerName(player) .. " #" .. player
    cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusActive .. ' ~c~(' .. tableConcat(cityPrioPlayers, ", ") .. ")"
    TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
  end
end, false)

-- Priority End Function -- 

RegisterCommand(Config.Priorities.City_Priority.Commands.PrioEnd, function(source, args, rawCommand)
  local player = source
  if not cityPrioActive then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~There is no priority that needs to be ended!"}
    })
    CityPrioEnd_Fail('SimplePrio \n', '**→ City Priority End Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There wasn\'t an active priority to be ended!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioEnd .. '*')
    return
  end
  if Config.Priorities.City_Priority.TextSettings.CooldownSettings.CooldownTimer > 1 then
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~y~ALERT: ~r~A citywide priority has been ~r~ended ~r~by ~o~" .. GetPlayerName(source) .. "~r~! Cooldown is now in effect for " .. Config.Priorities.City_Priority.TextSettings.CooldownSettings.CooldownTimer .. ' minutes!'}
    })
  else
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~y~ALERT: ~r~A citywide priority has been ~r~ended ~r~by ~o~" .. GetPlayerName(source) .. "~r~! Cooldown is now in effect for " .. Config.Priorities.City_Priority.TextSettings.CooldownSettings.CooldownTimer .. ' minute!'}
    })
  end
  CityPrioEnd_Success('SimplePrio \n', '**→ City Priority Ended by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True*\n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioEnd .. '*')
  cityPrioPlayers = {}
  cityCooldown(Config.Priorities.City_Priority.TextSettings.CooldownSettings.CooldownTimer)
end, false)

-- Priority Cooldown Function -- 

RegisterCommand(Config.Priorities.City_Priority.Commands.PrioCooldown, function(source, args, rawCommand)
  local player = source
  local time = tonumber(args[1])

  if cityPrioCooldown then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~y~There is already a city cooldown active! Please wait for the current cooldown to end before starting another cooldown!"}
    })
    CityPrioCooldown_Fail('SimplePrio \n', '**→ City Priority Cooldown Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There is currently an active cooldown! You cannot have 2 cooldowns running!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioCooldown .. '*')
  else
    if IsPlayerAceAllowed(source, Config.Permissions.CooldownAcePermission) then 
      if time > 1 then
        TriggerClientEvent("chat:addMessage", -1, {
          color = {255, 0, 0},
          multiline = true,
          args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~y~A citywide priority cooldown has started by ~b~" .. GetPlayerName(source) .. "~y~ for ~r~" .. time .. ' minutes!'}
        })
      else
        TriggerClientEvent("chat:addMessage", -1, {
          color = {255, 0, 0},
          multiline = true,
          args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~y~A citywide priority cooldown has started by ~b~" .. GetPlayerName(source) .. "~y~ for ~r~" .. time .. ' minute!'}
        })
      end
      CityPrioCooldown_Success('SimplePrio \n', '**→ City Priority Cooldown Started by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True* \n**→ Cooldown Timer:** *' .. time .. '*\n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioCooldown .. '*')
      if time and time > 0 then
        cityCooldown(time)
      end
    else
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You do not have permissions to use this command!"}
      })
      CityPrioCooldown_Fail('SimplePrio \n', '**→ City Priority Cooldown Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *This user lacks permissions to use this command!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioCooldown .. '*')
    end
  end
end, false)

-- Priority Joining Function -- 

RegisterCommand(Config.Priorities.City_Priority.Commands.JoinPrio, function(source, args, rawCommand)
  local player = source
  if not cityPrioActive then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~There is not an active priority in the city that you can join!"}
    })
    CityPrioJoin_Fail('SimplePrio \n', '**→ City Priority Join Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There is no active priority for this user to join!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.JoinPrio .. '*')
    return
  end
  if cityPrioPlayers[player] then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You are already apart of this priority!"}
    })
    return
  end
  CityPrioJoin_Success('SimplePrio \n', '**→ City Priority Joined by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.JoinPrio .. '*')
  cityPrioPlayers[player] = GetPlayerName(player) .. ' #' .. player
  cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusActive .. ' ~c~(' .. tableConcat(cityPrioPlayers, ", ") .. ")"
  TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio) 
end, false)

-- Priority Leaving Function -- 

RegisterCommand(Config.Priorities.City_Priority.Commands.LeavePrio, function(source, args, rawCommand)
  local player = source
  if not cityPrioActive then
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~There is not an active priority you can leave!"}
    })
    CityPrioLeave_Fail('SimplePrio \n', '**→ City Priority Leave Attempt by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n** → Fail Details:** *There is no active priority for you to leave!*\n \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.LeavePrio .. '*')
    return
  end
  if tableCount(cityPrioPlayers) == 1 and cityPrioPlayers[player] == (GetPlayerName(player) .. ' #' .. player) then
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~y~All players have left the active priority! Citywide Cooldown started automatically from ~b~SimplePrio~y~!"}
    })
    cityPrioPlayers = {}
    cityCooldown(Config.Priorities.City_Priority.TextSettings.CooldownSettings.CooldownTimer)
    cityPrioActive = false
  else
    TriggerClientEvent("chat:addMessage", -1, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~" .. GetPlayerName(source) .. ' ~y~has left the active city priority!'}
    })
    CityPrioLeave_Success('SimplePrio \n', '**→ City Priority Left by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.LeavePrio .. '*')
    cityPrioPlayers[player] = nil
    cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusActive .. ' ~c~(' .. tableConcat(cityPrioPlayers, ", ") .. ")"
  end
  TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio) 
end, false)

-- Priority Reset Function -- 

RegisterCommand(Config.Priorities.City_Priority.Commands.PrioAvailable, function(source, args, rawCommand)
  local player = source
  if IsPlayerAceAllowed(source, Config.Permissions.ResetAcePermissions) then 
    if cityPrioActive then
      cityPrioPlayers = {}
      cityPrioActive = false
      cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusAvailable
    elseif cityPrioCooldown then
      TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~ You cannot reset the system as cooldown is ~g~enabled~b~! Please wait!"}
      })
    elseif cityPrioHold then
      cityPrioHold = false
      cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusAvailable
    else
      TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~" .. GetPlayerName(source) .. ' ~y~has reset the citywide priority system!'}
      })
      CityPrioReset_Success('SimplePrio \n', '**→ City Priority System Reset by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *True* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioAvailable .. '*')
      TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio) 
    end
  else
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You lack the permissions requried to run this command!"}
    })
    CityPrioReset_Fail('SimplePrio \n', '**→ City Priority System Reset by: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n**→ Fail Details:** *This user lacks permissions to run this command!* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioAvailable .. '*')
  end
end, false)

-- Priority on Hold Function --

RegisterCommand(Config.Priorities.City_Priority.Commands.PrioOnHold, function(source, args, rawCommand)
  local player = source
  if IsPlayerAceAllowed(source, Config.Permissions.OnHoldAcePermission) then
    if cityPrioHold == true then
      cityPrioHold = false
      cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusAvailable
      TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~" .. GetPlayerName(source) .. ' ~y~has ~r~disabled~y~ city priorities being on hold!'}
      })
      CityPrioHold_Disabled('SimplePrio \n', '**→ City Priority Hold Changed By: __' .. GetPlayerName(source) .. '__ \n ** **→ Hold Status: ** *Disabled* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioOnHold .. '*')
    else
      cityPrioHold = true
      cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages.StatusOnHold
      TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "~r~ALERT: ~b~" .. GetPlayerName(source) .. ' ~y~has ~g~enabled~y~ city priorities being on hold!'}
      })
      CityPrioHold_Enabled('SimplePrio \n', '**→ County Priority Hold Changed By: __' .. GetPlayerName(source) .. '__ \n ** **→ Hold Status: ** *Enabled* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioOnHold .. '*')
    end
    TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio) 
  else
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You lack the permissions requried to run this command!"}
    })
    CityPrioHold_Fail('SimplePrio \n', '**→ City Priority Hold Change Attempt By: __' .. GetPlayerName(source) .. '__ \n ** **→ Successful: ** *False* \n**→ Fail Details:** *This user lacks permissions to run this command!* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Priorities.City_Priority.Commands.PrioOnHold .. '*')
  end
end, false)


-- Peacetime Function --

local peacetimeon = false

RegisterServerEvent('SimplePrio:peacetime:Sync')
AddEventHandler('SimplePrio:peacetime:Sync', function()
  TriggerClientEvent('SimplePrio:peacetime', -1, peacetimeon)
end)

if Config.Peacetime.FrameworkSettings.Framework == 'nat' then
  RegisterNetEvent('SimplePrio:GetPermissions')
  AddEventHandler('SimplePrio:GetPermissions', function()
    local src = source
    if checkPerms(src) then
      TriggerClientEvent('SimplePrio:RefreshPermissions', src, true)
    end
  end)

  function checkPerms(src)
    local player = exports[Config.Peacetime.FrameworkSettings.FrameworkName]:getdept(src)
    if player then
      if player[src].level == Config.Peacetime.FrameworkSettings.DepartmentInfo.NAT2K15_Framework.State_Level or player[src].level == Config.Peacetime.FrameworkSettings.DepartmentInfo.NAT2K15_Framework.Police_Level or player[src].level == Config.Peacetime.FrameworkSettings.DepartmentInfo.NAT2K15_Framework.Sheriff_Level or player[src].level == Config.Peacetime.FrameworkSettings.DepartmentInfo.NAT2K15_Framework.Admin_Level then
        return true
      else
        return false
      end
    else
      return false
    end
  end
end

RegisterCommand(Config.Peacetime.Commands.Peacetime, function(source, args, rawCommand)
  local player = source
  if IsPlayerAceAllowed(source, Config.Permissions.PeacetimeAcePermission) then
    if peacetimeon then
      TriggerClientEvent("chat:addMessage", -1, {
          color = {255, 0, 0},
          multiline = true,
          args = {"~w~[~b~SimplePrio~w~] ", "Peacetime has been ~r~disabled~w~ by ~r~" .. GetPlayerName(source) .. "~w~!"}
      })
      Peacetime_Disabled('SimplePrio \n', '**→ Statewide Peacetime Changed By: __' .. GetPlayerName(source) .. '__ \n ** **→ Peacetime Status: ** *Disabled* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Peacetime.Commands.Peacetime .. '*')
      peacetimeon = false
      TriggerEvent("SimplePrio:peacetime:Sync", peacetimeon)
    else
      TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"~w~[~b~SimplePrio~w~] ", "Peacetime has been ~g~enabled~w~ by ~r~" .. GetPlayerName(source) .. "~w~!"}
      })
      Peacetime_Enabled('SimplePrio \n', '**→ Statewide Peacetime Changed By: __' .. GetPlayerName(source) .. '__ \n ** **→ Peacetime Status: ** *Enabled* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Peacetime.Commands.Peacetime .. '*')
      peacetimeon = true
      TriggerEvent('SimplePrio:peacetime:Sync', peacetimeon)
      if Config.Peacetime.FrameworkSettings.Framework == 'nd' or Config.Peacetime.FrameworkSettings.Framework == 'nat' then
        TriggerClientEvent('SimplePrio:CheckJob', -1)
      end
    end
  else
    TriggerClientEvent("chat:addMessage", player, {
      color = {255, 0, 0},
      multiline = true,
      args = {"~w~[~b~SimplePrio~w~] ", "~r~ERROR: ~y~You lack permissions needed to run this command!"}
    })
    Peacetime_Failed('SimplePrio \n', '**→ Statewide Peacetime Change Attempted By: __' .. GetPlayerName(source) .. '__ \n ** **→ Change Success:** *False* \n**→ Time command was executed:** *' .. timestamp .. '* \n **→ Command Used: ** *' .. Config.Peacetime.Commands.Peacetime .. '*')
  end
end)

-- County Logging Functions --

 -- Active Priority Logging --
function CPrioStart_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680', -- Color = Red
      ["title"] = "**County Priority System Logs**", 
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.StartPriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CPrioStart_Success(name, message)
  local content = {
    {
      ["color"] =  '65280', -- Color = Green
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.StartPriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Cooldown Priority Logging --

function CPrioCooldown_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.StartCooldown, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CPrioCooldown_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.StartCooldown, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Priority End Logging --

function CPrioEnd_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.PriorityEnd, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CPrioEnd_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.PriorityEnd, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Joinning Priority Logging --

function CPrioJoin_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.JoinPriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CPrioJoin_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.JoinPriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Leaving Priority Logging --

function CPrioLeave_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.LeavePriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CPrioLeave_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.LeavePriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Reset Priority Logging --

function CPrioReset_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.SystemReset, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CPrioReset_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.SystemReset, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- On Hold Priority Logging --

function CPrioHold_Disabled(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.StartOnHold, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CPrioHold_Enabled(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.StartOnHold, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CPrioHold_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**County Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.County.StartOnHold, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- City Logging Functions --

 -- Active Priority Logging --
 function CityPrioStart_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680', -- Color = Red
      ["title"] = "**City Priority System Logs**", 
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.StartPriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CityPrioStart_Success(name, message)
  local content = {
    {
      ["color"] =  '65280', -- Color = Green
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.StartPriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Cooldown Priority Logging --

function CityPrioCooldown_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.StartCooldown, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CityPrioCooldown_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.StartCooldown, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Priority End Logging --

function CityPrioEnd_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.PriorityEnd, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CityPrioEnd_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.PriorityEnd, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Joinning Priority Logging --

function CityPrioJoin_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.JoinPriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CityPrioJoin_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.JoinPriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Leaving Priority Logging --

function CityPrioLeave_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.LeavePriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CityPrioLeave_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.LeavePriority, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Reset Priority Logging --

function CityPrioReset_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.SystemReset, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CityPrioReset_Success(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.SystemReset, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- On Hold Priority Logging --

function CityPrioHold_Disabled(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.StartOnHold, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CityPrioHold_Enabled(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.StartOnHold, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function CityPrioHold_Fail(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.City.StartOnHold, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- Peacetime Logging --

function Peacetime_Disabled(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.Peacetime.PeacetimeDisabled, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function Peacetime_Enabled(name, message)
  local content = {
    {
      ["color"] =  '65280',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.Peacetime.PeacetimeEnabled, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function Peacetime_Failed(name, message)
  local content = {
    {
      ["color"] =  '16711680',
      ["title"] = "**City Priority System Logs**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = 'Made by SimpleDevelopments'
      }
    }
  }
  PerformHttpRequest(Config.Logging.Peacetime.PeacetimeInvalidPerms, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end
