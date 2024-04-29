-- Grabs core systems from ND_Core if being used. --
if Config.Peacetime.FrameworkSettings.Framework == 'nd' then
    NDCore = exports["ND_Core"]:GetCoreObject()
end

-- Peacetime Locals --
local timestamp = os.date("%c")
local isCop = false
local peacetimeon = false
local peacetimeStatus = "off"

-- County Priority Locals --
local countyPrio = Config.Priorities.City_Priority.TextSettings.DefaultStatus
local countyPrioCooldown = false
local countyPrioHold = false
local countyPrioActive = false
local countyPrioPlayers = {}
local countyCooldown = 0
local numPlayersInCountyPrio = 0

-- City Priority Locals -- 
local cityPrio = Config.Priorities.City_Priority.TextSettings.DefaultStatus
local cityPrioCooldown = false
local cityPrioHold = false
local cityPrioActive = false
local cityPrioPlayers = {}
local cityCooldown = 0
local numPlayersInCityPrio = 0

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--                Player Table Verification Functions                --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

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
    for _ in pairs(table) do count = count + 1 end
    return count
end

function UpdateNumPlayersInCountyPrio(playerCount)
    numPlayersInCountyPrio = playerCount
end

function UpdateNumPlayersInCityPrio(playerCount)
    numPlayersInCityPrio = playerCount
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--                     Priority Cooldown Functions                   --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------ 

function countyCooldown(time)
    countyPrioActive = false
    countyPrioCooldown = true
    for countyCooldown = time, 1, -1 do
        if countyCooldown > 1 then
            countyPrio = Config.Priorities.County_Priority.TextSettings
                             .StatusMessages.StatusOnCooldown .. ' ~c~(~y~' ..
                             countyCooldown .. '~c~ minutes)'
        else
            countyPrio = Config.Priorities.County_Priority.TextSettings
                             .StatusMessages.StatusOnCooldown .. ' ~c~(~y~' ..
                             countyCooldown .. '~c~ minute)'
        end
        TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
        Citizen.Wait(60000)
    end
    countyPrio = Config.Priorities.County_Priority.TextSettings.StatusMessages
                     .StatusAvailable
    TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
    countyPrioCooldown = false
end

function cityCooldown(time)
    cityPrioActive = false
    cityPrioCooldown = true
    for cityCooldown = time, 1, -1 do
        if cityCooldown > 1 then
            cityPrio = Config.Priorities.City_Priority.TextSettings
                           .StatusMessages.StatusOnCooldown .. ' ~c~(~y~' ..
                           cityCooldown .. '~c~ minutes)'
        else
            cityPrio = Config.Priorities.City_Priority.TextSettings
                           .StatusMessages.StatusOnCooldown .. ' ~c~(~y~' ..
                           cityCooldown .. '~c~ minute)'
        end
        TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
        Citizen.Wait(60000)
    end
    cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages
                   .StatusAvailable
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

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--               Viewing players in a Priority Function              --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

RegisterCommand('priolist', function(source, args, rawCommand)
    -- Check if the command has arguments
    if #args == 0 then
        -- If no arguments provided, show usage message
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"[SimplePrio] ", "Usage: /priolist <county/city>"}
        })
        return
    end

    local prioType = args[1]

    -- Create a string to store the list of player names and numbers
    local playerList = ""

    -- Counter for player numbers
    local playerNumber = 1

    -- Check the type of priority specified
    if prioType == "county" then
        -- Check if there are players in county priority
        if next(countyPrioPlayers) == nil then
            playerList = "No players in county priority."
        else
            -- Loop through the players in county priority and add their names and numbers to the list
            for player, _ in pairs(countyPrioPlayers) do
                -- Check if the player is in the server before getting their name
                if GetPlayerName(player) ~= nil then
                    playerList = playerList .. playerNumber .. ". " ..
                                     GetPlayerName(player) .. "\n"
                    playerNumber = playerNumber + 1
                else
                    playerList = playerList .. playerNumber ..
                                     ". ~y~Unknown Player - ~r~Player left?\n" -- If player not in server
                    playerNumber = playerNumber + 1
                end
            end
        end
    elseif prioType == "city" then
        -- Check if there are players in city priority
        if next(cityPrioPlayers) == nil then
            playerList = "No players in city priority."
        else
            -- Loop through the players in city priority and add their names and numbers to the list
            for player, _ in pairs(cityPrioPlayers) do
                -- Check if the player is in the server before getting their name
                if GetPlayerName(player) ~= nil then
                    playerList = playerList .. playerNumber .. ". " ..
                                     GetPlayerName(player) .. "\n"
                    playerNumber = playerNumber + 1
                else
                    playerList = playerList .. playerNumber ..
                                     ". ~y~Unknown Player - ~r~Player left?\n" -- If player not in server
                    playerNumber = playerNumber + 1
                end
            end
        end
    else
        -- If invalid priority type specified, show error message
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {
                "[SimplePrio]", "Invalid priority type. Use 'county' or 'city'."
            }
        })
        return
    end

    -- Send the list of player names or the no players message to the player who used the command
    TriggerClientEvent('chat:addMessage', source, {
        color = {255, 255, 255},
        multiline = true,
        args = {
            "~w~[~b~SimplePrio~w~]  ",
            "Players in " .. prioType .. " priority:\n" .. playerList
        }
    })
end, false)

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--                 Help Function For Priority System                 --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

RegisterCommand('priohelp', function(source, args, rawCommand)
    if args == nil then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"~w~[~b~SimplePrio~w~] ", "Usage: /priohelp <type>"}
        })
    end

    if args[1] == Config.Priorities.County_Priority.Commands.mainCommand then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 255},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "Commands for County Prio: \n /priority " ..
                    Config.Priorities.County_Priority.Commands.mainCommand ..
                    ' ' .. Config.Priorities.County_Priority.Commands.StartPrio ..
                    "\n /priority " ..
                    Config.Priorities.County_Priority.Commands.mainCommand ..
                    ' ' .. Config.Priorities.County_Priority.Commands.EndPrio ..
                    "\n /priority " ..
                    Config.Priorities.County_Priority.Commands.mainCommand ..
                    ' ' .. Config.Priorities.County_Priority.Commands.JoinPrio ..
                    "\n /priority " ..
                    Config.Priorities.County_Priority.Commands.mainCommand ..
                    ' ' .. Config.Priorities.County_Priority.Commands.LeavePrio ..
                    "\n /priority " ..
                    Config.Priorities.County_Priority.Commands.mainCommand ..
                    ' ' ..
                    Config.Priorities.County_Priority.Commands.PrioCooldown ..
                    "\n /priority " ..
                    Config.Priorities.County_Priority.Commands.mainCommand ..
                    ' ' .. Config.Priorities.County_Priority.Commands.PrioReset ..
                    "\n /priority " ..
                    Config.Priorities.County_Priority.Commands.mainCommand ..
                    ' ' .. Config.Priorities.County_Priority.Commands.PrioOnHold
            }
        })
    elseif args[1] == Config.Priorities.City_Priority.Commands.mainCommand then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 255},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "Commands for City Prio: \n /priority " ..
                    Config.Priorities.City_Priority.Commands.mainCommand .. ' ' ..
                    Config.Priorities.City_Priority.Commands.StartPrio ..
                    "\n /priority " ..
                    Config.Priorities.City_Priority.Commands.mainCommand .. ' ' ..
                    Config.Priorities.City_Priority.Commands.EndPrio ..
                    "\n /priority " ..
                    Config.Priorities.City_Priority.Commands.mainCommand .. ' ' ..
                    Config.Priorities.City_Priority.Commands.JoinPrio ..
                    "\n /priority " ..
                    Config.Priorities.City_Priority.Commands.mainCommand .. ' ' ..
                    Config.Priorities.City_Priority.Commands.LeavePrio ..
                    "\n /priority " ..
                    Config.Priorities.City_Priority.Commands.mainCommand .. ' ' ..
                    Config.Priorities.City_Priority.Commands.PrioCooldown ..
                    "\n /priority " ..
                    Config.Priorities.City_Priority.Commands.mainCommand .. ' ' ..
                    Config.Priorities.City_Priority.Commands.PrioReset ..
                    "\n /priority " ..
                    Config.Priorities.City_Priority.Commands.mainCommand .. ' ' ..
                    Config.Priorities.City_Priority.Commands.PrioOnHold
            }
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {
                "~w~[~b~SimplePrio~w~] ",
                "Invalid Priority System, Usage: /priohelp <" ..
                    Config.Priorities.County_Priority.Commands.mainCommand ..
                    "/" .. Config.Priorities.City_Priority.Commands.mainCommand ..
                    ">"
            }
        })
    end
end)

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--                   Priority Script Command HUB                     --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

RegisterCommand('priority', function(source, args, rawCommand)
    local player = source
    -- Check if the command has arguments
    if args == nil or #args < 2 then
        -- If not enough arguments provided, show usage message
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {
                "~w~[~b~SimplePrio~w~] ", "Usage: /priority <type> <action>"
            }
        })
        return
    end

    local type = args[1]
    local action = args[2]
    local defaultCountyTimer = Config.Priorities.County_Priority.TextSettings
                                   .CooldownSettings.CooldownTimer
    local defaultCityTimer = Config.Priorities.City_Priority.TextSettings
                                 .CooldownSettings.CooldownTimer

    -- Check if the type and action are not nil
    if type == nil or action == nil then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {
                "~w~[~b~SimplePrio~w~] ",
                "Invalid arguments provided. Usage: /priority <type> <action>"
            }
        })
        return
    end
    -- Check the type specified
    if type == Config.Priorities.County_Priority.Commands.mainCommand then
        -- Check the action specified for countywide priority
        if action == Config.Priorities.County_Priority.Commands.StartPrio then
            StartCountyPriority(source)
        elseif action == Config.Priorities.County_Priority.Commands.EndPrio then
            EndCountyPriority(source)
        elseif action == Config.Priorities.County_Priority.Commands.JoinPrio then
            JoinCountyPriority(player)
        elseif action == Config.Priorities.County_Priority.Commands.LeavePrio then
            LeaveCountyPriority(player)
        elseif action == Config.Priorities.County_Priority.Commands.PrioCooldown then
            if args[3] ~= nil then
                defaultCountyTimer = tonumber(args[3])
            end
            StartCountyCooldown(source, defaultCountyTimer)
        elseif action == Config.Priorities.County_Priority.Commands.PrioReset then
            ResetCountyPriority(player)
        elseif action == Config.Priorities.County_Priority.Commands.PrioOnHold then
            ToggleCountyPriorityHold(player)
        else
            -- If invalid action specified for countywide priority, show error message
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {
                    "~w~[~b~SimplePrio~w~] ",
                    "Invalid action for countywide priority. Use 'start', 'end', 'cooldown', 'hold', or 'reset'."
                }
            })
            return
        end
    elseif type == Config.Priorities.City_Priority.Commands.mainCommand then
        -- Check the action specified for countywide priority
        if action == Config.Priorities.City_Priority.Commands.StartPrio then
            StartCityPriority(source)
        elseif action == Config.Priorities.City_Priority.Commands.EndPrio then
            EndCityPriority(source)
        elseif action == Config.Priorities.City_Priority.Commands.JoinPrio then
            JoinCityPriority(player)
        elseif action == Config.Priorities.City_Priority.Commands.LeavePrio then
            LeaveCityPriority(player)
        elseif action == Config.Priorities.City_Priority.Commands.PrioCooldown then
            if args[3] ~= nil then
                defaultCityTimer = tonumber(args[3])
            end
            StartCityCooldown(source, defaultCityTimer)
        elseif action == Config.Priorities.City_Priority.Commands.PrioReset then
            ResetCityPriority(player)
        elseif action == Config.Priorities.City_Priority.Commands.PrioOnHold then
            ToggleCityPriorityHold(player)
        else
            -- If invalid action specified for citywide priority, show error message
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {
                    "~w~[~b~SimplePrio~w~] ",
                    "Invalid action for citywide priority. Use 'start', 'end', 'cooldown', 'hold', or 'reset'."
                }
            })
            return
        end
    else
        -- If invalid type specified, show error message
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {
                "~w~[~b~SimplePrio~w~]  ", 'Invalid priority type. Use "' ..
                    Config.Priorities.City_Priority.Commands.mainCommand ..
                    '" or "' ..
                    Config.Priorities.County_Priority.Commands.mainCommand ..
                    '".'
            }
        })
        return
    end
end, false)

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--              Starting a Countywide Priority Function              --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

function StartCountyPriority(source)
    local player = source
    if countyPrioCooldown then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You cannot start a priority due to cooldown!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *Countywide Priority Cooldown is currently active!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.StartPrio ..
                            '*.')
        return
    elseif countyPrioHold then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You cannot start a priority due to it being on hold!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *The countywide priority system is currently on hold!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.StartPrio ..
                            '*.')
        return
    elseif countyPrioActive then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~~w~[~b~SimplePrio~w~] : ",
                "~r~ERROR: ~y~You cannot start a priority as one is already started!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There is currently already a priority active within county limits!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.StartPrio ..
                            '*.')
        return
    elseif peacetimeon then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~~w~[~b~SimplePrio~w~] ",
                "~r~ERROR: ~y~You cannot start a priority whilst peacetime is on!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *Peacetime is enabled!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.StartPrio ..
                            '*.')
    else
        countyPrioActive = true
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~y~ALERT: ~r~A countywide priority has been ~g~started ~r~by ~o~" ..
                    GetPlayerName(player) .. "~r~!"
            }
        })
        countyPrioPlayers[player] = GetPlayerName(player) .. " #" .. player
        -- Update the countyPrio variable whenever the count changes
        UpdateNumPlayersInCountyPrio(numPlayersInCountyPrio + 1)
        countyPrio = Config.Priorities.County_Priority.TextSettings
                         .StatusMessages.StatusActive .. '~c~ (~w~' ..
                         numPlayersInCountyPrio ..
                         '/4~c~ in priority) (~w~/priolist~c~)'
        TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Priority Status in the county has been started*\n **→ Priority System (City / County):** *County*\n \n*→' ..
                               numPlayersInCountyPrio ..
                               '/4* **Players in County Priority!**\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.County_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.County_Priority.Commands
                                   .StartPrio .. '*.')
    end
end

function StartCityPriority(source)
    local player = source
    if peacetimeon then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~~w~[~b~SimplePrio~w~] ",
                "~r~ERROR: ~y~You cannot start a priority whilst peacetime is on!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *Peacetime is enabled!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.StartPrio ..
                            '*.')
    elseif cityPrioCooldown then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You cannot start a priority due to cooldown!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *Citywide Priority Cooldown is currently active!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands
                                .PrioCooldown .. '*.')
        return
    elseif cityPrioHold then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You cannot start a priority due to it being on hold!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *The citywide priority system is currently on hold!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.PrioOnHold ..
                            '*.')
    elseif cityPrioActive then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~~w~[~b~SimplePrio~w~] : ",
                "~r~ERROR: ~y~You cannot start a priority as one is already started!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There is currently already a priority active within city limits!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.StartPrio ..
                            '*.')
        return
    else
        cityPrioActive = true
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~y~ALERT: ~r~A citywide priority has been ~g~started ~r~by ~o~" ..
                    GetPlayerName(player) .. "~r~!"
            }
        })
        cityPrioPlayers[player] = GetPlayerName(player) .. " #" .. player
        -- Update the countyPrio variable whenever the count changes
        UpdateNumPlayersInCityPrio(numPlayersInCityPrio + 1)
        cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages
                       .StatusActive .. '~c~ (~w~' .. numPlayersInCityPrio ..
                       '/4~c~ in priority) (~w~/priolist~c~)'
        TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Priority Status in the city has been started*\n **→ Priority System (City / County):** *City*\n \n*→' ..
                               numPlayersInCityPrio ..
                               '/4* **Players in City Priority!**\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.City_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.City_Priority.Commands
                                   .StartPrio .. '*.')
    end
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--               Ending a Countywide Priority Function               --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

function EndCountyPriority(source)
    local player = source
    if not countyPrioActive then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~There is no priority that needs to be ended!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There currently is no priority within the county that needs to be ended!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.EndPrio ..
                            '*.')
        return
    end
    if countyPrioPlayers[player] then
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ", '~b~' .. GetPlayerName(player) ..
                    ' ~r~has ended the priority in the county! Cooldown has been started!'
            }
        })
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Priority has been ended and put into cooldown!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.County_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.County_Priority.Commands
                                   .EndPrio .. '*.')
        countyPrioPlayers = {}
        numPlayersInCountyPrio = 0
        countyCooldown(Config.Priorities.County_Priority.TextSettings
                           .CooldownSettings.CooldownTimer)
    else
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~y~ALERT: ~r~You cannot end this priority as you are not a part of the priority!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There currently is no priority within the county that needs to be ended!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.EndPrio ..
                            '*.')
    end
end

function EndCityPriority(source)
    local player = source
    if not cityPrioActive then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~There is no priority that needs to be ended!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There currently is no priority within the city that needs to be ended!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.EndPrio ..
                            '*.')
        return
    end
    if cityPrioPlayers[player] then
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ", '~b~' .. GetPlayerName(player) ..
                    ' ~r~has ended the priority in the city! Cooldown has been started!'
            }
        })
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Priority has been ended and put into cooldown!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.City_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.City_Priority.Commands.EndPrio ..
                               '*.')
        cityPrioPlayers = {}
        numPlayersInCityPrio = 0
        cityCooldown(Config.Priorities.City_Priority.TextSettings
                         .CooldownSettings.CooldownTimer)
    else
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~y~ALERT: ~r~You cannot end this priority as you are not a part of the priority!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There currently is no priority within the city that needs to be ended!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.EndPrio ..
                            '*.')
    end
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--             Starting a Countywide Cooldown Function               --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

function StartCountyCooldown(player, time)
    local playerName = GetPlayerName(player)
    if countyPrioHold then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~b~You cannot put cooldown on as the system is on hold!"
            }
        })
    elseif countyPrioCooldown then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ALERT: ~y~There is already a county cooldown active! Please wait for the current cooldown to end before starting another cooldown!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. playerName ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There is currently already a countywide priority cooldown in effect!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands
                                .PrioCooldown .. '*.')
        return
    else
        if IsPlayerAceAllowed(player, Config.Permissions.CooldownAcePermission) then
            if time > 1 then
                TriggerClientEvent("chat:addMessage", -1, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {
                        "~w~[~b~SimplePrio~w~]  ",
                        "~r~ALERT: ~y~A countywide priority cooldown has started by ~b~" ..
                            playerName .. "~y~ for ~r~" .. time .. ' minutes!'
                    }
                })
            else
                TriggerClientEvent("chat:addMessage", -1, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {
                        "~w~[~b~SimplePrio~w~]  ",
                        "~r~ALERT: ~y~A countywide priority cooldown has started by ~b~" ..
                            playerName .. "~y~ for ~r~" .. time .. ' minute!'
                    }
                })
            end
            countyPrioPlayers = {}
            numPlayersInCountyPrio = 0
            if time > 1 then
                SimplePrio_Success('SimplePrio  \n', '**→ ' .. playerName ..
                                       ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Countywide Cooldown has been started!*\n **→ Priority System (City / County):** *County*\n**→ Time Set:** *' ..
                                       time ..
                                       ' minutes*\n  \n**→ Time command was executed:** *' ..
                                       timestamp ..
                                       '* \n **→ Command Used: ** */priority ' ..
                                       Config.Priorities.County_Priority
                                           .Commands.mainCommand .. ' ' ..
                                       Config.Priorities.County_Priority
                                           .Commands.PrioCooldown .. '*.')
            else
                SimplePrio_Success('SimplePrio  \n', '**→ ' .. playerName ..
                                       ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Countywide Cooldown has been started!*\n **→ Priority System (City / County):** *County*\n**→ Time Set:** *' ..
                                       time ..
                                       ' minute*\n  \n**→ Time command was executed:** *' ..
                                       timestamp ..
                                       '* \n **→ Command Used: ** */priority ' ..
                                       Config.Priorities.County_Priority
                                           .Commands.mainCommand .. ' ' ..
                                       Config.Priorities.County_Priority
                                           .Commands.PrioCooldown .. '*.')
            end
            if time and time > 0 then countyCooldown(time) end
        else
            TriggerClientEvent("chat:addMessage", player, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "~w~[~b~SimplePrio~w~]  ",
                    "~r~ERROR: ~y~You do not have permissions to use this command!"
                }
            })
            SimplePrio_Fail('SimplePrio  \n', '**→ ' .. playerName ..
                                ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user lacks the required permissions *\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                                timestamp ..
                                '* \n **→ Command Used: ** */priority ' ..
                                Config.Priorities.County_Priority.Commands
                                    .mainCommand .. ' ' ..
                                Config.Priorities.County_Priority.Commands
                                    .PrioCooldown .. '*.')
        end
    end
end

function StartCityCooldown(player, time)
    local playerName = GetPlayerName(player)
    if cityPrioHold then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~b~You cannot put cooldown on as the system is on hold!"
            }
        })
    elseif cityPrioCooldown then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ALERT: ~y~There is already a city cooldown active! Please wait for the current cooldown to end before starting another cooldown!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. playerName ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There is currently already a citywide priority cooldown in effect!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands
                                .PrioCooldown .. '*.')
        return
    else
        if IsPlayerAceAllowed(player, Config.Permissions.CooldownAcePermission) then
            if time > 1 then
                TriggerClientEvent("chat:addMessage", -1, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {
                        "~w~[~b~SimplePrio~w~]  ",
                        "~r~ALERT: ~y~A citywide priority cooldown has started by ~b~" ..
                            playerName .. "~y~ for ~r~" .. time .. ' minutes!'
                    }
                })
            else
                TriggerClientEvent("chat:addMessage", -1, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {
                        "~w~[~b~SimplePrio~w~]  ",
                        "~r~ALERT: ~y~A citywide priority cooldown has started by ~b~" ..
                            playerName .. "~y~ for ~r~" .. time .. ' minute!'
                    }
                })
            end
            if time > 1 then
                SimplePrio_Success('SimplePrio  \n', '**→ ' .. playerName ..
                                       ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Citywide cooldown has been started*\n **→ Priority System (City / County):** *City*\n**→ Time Set:** *' ..
                                       time ..
                                       ' minutes*\n  \n**→ Time command was executed:** *' ..
                                       timestamp ..
                                       '* \n **→ Command Used: ** */priority ' ..
                                       Config.Priorities.City_Priority.Commands
                                           .mainCommand .. ' ' ..
                                       Config.Priorities.City_Priority.Commands
                                           .PrioCooldown .. '*.')
            else
                SimplePrio_Success('SimplePrio  \n', '**→ ' .. playerName ..
                                       ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Citywide cooldown has been started!*\n **→ Priority System (City / County):** *City*\n**→ Time Set:** *' ..
                                       time ..
                                       ' minute*\n  \n**→ Time command was executed:** *' ..
                                       timestamp ..
                                       '* \n **→ Command Used: ** */priority ' ..
                                       Config.Priorities.City_Priority.Commands
                                           .mainCommand .. ' ' ..
                                       Config.Priorities.City_Priority.Commands
                                           .PrioCooldown .. '*.')
            end
            cityPrioPlayers = {}
            numPlayersInCityPrio = 0
            if time and time > 0 then cityCooldown(time) end
        else
            TriggerClientEvent("chat:addMessage", player, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "~w~[~b~SimplePrio~w~]  ",
                    "~r~ERROR: ~y~You do not have permissions to use this command!"
                }
            })
            SimplePrio_Fail('SimplePrio  \n', '**→ ' .. playerName ..
                                ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user lacks the required permissions *\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                                timestamp ..
                                '* \n **→ Command Used: ** */priority ' ..
                                Config.Priorities.City_Priority.Commands
                                    .mainCommand .. ' ' ..
                                Config.Priorities.City_Priority.Commands
                                    .PrioCooldown .. '*.')
        end
    end
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--               Joining an Active Priority Function                 --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

function JoinCountyPriority(player)
    if not countyPrioActive then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~There is not an active priority in the county that you can join!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user tried to join a priority that doesn\'t exist.*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.JoinPrio ..
                            '*.')
        return
    end

    if countyPrioPlayers[player] then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You are already apart of this priority!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user is already apart of the priority.*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.JoinPrio ..
                            '*.')
        return
    end

    if numPlayersInCountyPrio == 4 then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~Priority is full! Please wait for a slot to open!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *Priority is full!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.JoinPrio ..
                            '*.')
    else
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~y~ALERT: ~r~" .. GetPlayerName(player) ..
                    "has ~g~joined~r~ the county priority!"
            }
        })
        countyPrioPlayers[player] = GetPlayerName(player) .. ' #' .. player
        UpdateNumPlayersInCountyPrio(numPlayersInCountyPrio + 1)
        countyPrio = Config.Priorities.County_Priority.TextSettings
                         .StatusMessages.StatusActive .. '~c~ (~w~' ..
                         numPlayersInCountyPrio ..
                         '/4~c~ in priority) (~w~/priolist~c~)'
        TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *' ..
                               GetPlayerName(player) ..
                               ' has joined the countywide priority.*\n **→ Priority System (City / County):** *County*\n \n*→' ..
                               numPlayersInCountyPrio ..
                               '/4* **Players in County Priority!**\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.County_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.County_Priority.Commands
                                   .JoinPrio .. '*.')
    end
end

function JoinCityPriority(player)
    if not cityPrioActive then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~There is not an active priority in the city that you can join!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user tried to join a priority that doesn\'t exist.*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.JoinPrio ..
                            '*.')
        return
    end

    if cityPrioPlayers[player] then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You are already apart of this priority!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user is already apart of the priority.*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.JoinPrio ..
                            '*.')
        return
    end

    if numPlayersInCityPrio == 4 then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~Priority is full! Please wait for a slot to open!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *Priority is full!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.JoinPrio ..
                            '*.')
    else
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~y~ALERT: ~r~" .. GetPlayerName(player) ..
                    " has ~g~joined~r~ the city priority!"
            }
        })
        cityPrioPlayers[player] = GetPlayerName(player) .. ' #' .. player
        UpdateNumPlayersInCityPrio(numPlayersInCityPrio + 1)
        cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages
                       .StatusActive .. '~c~ (~w~' .. numPlayersInCityPrio ..
                       '/4~c~ in priority) (~w~/priolist~c~)'
        TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *' ..
                               GetPlayerName(player) ..
                               ' has joined the citywide priority.*\n **→ Priority System (City / County):** *City*\n \n*→' ..
                               numPlayersInCityPrio ..
                               '/4* **Players in City Priority!**\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.City_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.City_Priority.Commands.JoinPrio ..
                               '*.')
    end
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--               Leaving an Active Priority Function                 --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

function LeaveCountyPriority(player)
    if not countyPrioActive then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~There is not an active priority you can leave!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There wasn\'t any active priority that could be left.*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.LeavePrio ..
                            '*.')
        return
    end

    if tableCount(countyPrioPlayers) == 1 and countyPrioPlayers[player] ==
        GetPlayerName(player) .. ' #' .. player then
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ALERT: ~y~All players have left the active priority! Countywide Cooldown started automatically from ~b~SimplePrio~y~!"
            }
        })
        countyPrioPlayers = {}
        numPlayersInCountyPrio = 0
        countyCooldown(Config.Priorities.County_Priority.TextSettings
                           .CooldownSettings.CooldownTimer)
        countyPrioActive = false
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Due to everyone leaving priority, Priority has been ended automatically and set into cooldown!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.County_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.County_Priority.Commands
                                   .LeavePrio .. '*.')
    else
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~y~ALERT: ~r~" .. GetPlayerName(player) ..
                    " has ~g~left~r~ the county priority!"
            }
        })
        countyPrioPlayers[player] = nil
        UpdateNumPlayersInCountyPrio(numPlayersInCountyPrio - 1)
        countyPrio = Config.Priorities.County_Priority.TextSettings
                         .StatusMessages.StatusActive .. '~c~ (~w~' ..
                         numPlayersInCountyPrio ..
                         '/4~c~ in priority) (~w~/priolist~c~)'
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user has left the priority that is active!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.County_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.County_Priority.Commands
                                   .LeavePrio .. '*.')
    end

    TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
end

function LeaveCityPriority(player)
    if not cityPrioActive then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~There is not an active priority you can leave!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *There wasn\'t any active priority that could be left.*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.LeavePrio ..
                            '*.')
        return
    end

    if tableCount(cityPrioPlayers) == 1 and cityPrioPlayers[player] ==
        GetPlayerName(player) .. ' #' .. player then
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ALERT: ~y~All players have left the active priority! Citywide Cooldown started automatically from ~b~SimplePrio~y~!"
            }
        })
        cityPrioPlayers = {}
        numPlayersInCityPrio = 0
        cityCooldown(Config.Priorities.City_Priority.TextSettings
                         .CooldownSettings.CooldownTimer)
        cityPrioActive = false
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Due to everyone leaving priority, Priority has been ended automatically and set into cooldown!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.City_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.City_Priority.Commands
                                   .LeavePrio .. '*.')
    else
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~y~ALERT: ~r~" .. GetPlayerName(player) ..
                    " has ~g~left~r~ the city priority!"
            }
        })
        cityPrioPlayers[player] = nil
        UpdateNumPlayersInCityPrio(numPlayersInCityPrio - 1)
        cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages
                       .StatusActive .. '~c~ (~w~' .. numPlayersInCityPrio ..
                       '/4~c~ in priority) (~w~/priolist~c~)'
        SimplePrio_Success('SimplePrio  \n',
                           '**→ ' .. GetPlayerName(player) ..
                               ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user has left the priority that is active!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.City_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.City_Priority.Commands
                                   .LeavePrio .. '*.')
    end

    TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--              Resetting an Active Priority Function                --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

function ResetCountyPriority(player)
    local playerName = GetPlayerName(player)

    -- Check if the player has the required permission
    if not IsPlayerAceAllowed(player, Config.Permissions.ResetAcePermissions) then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You lack the permissions required to run this command!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. playerName ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user lacks permissions required to use this command!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.PrioReset ..
                            '*.')
        return
    end

    -- Reset the county priority
    if countyPrioActive or countyPrioHold then
        -- Reset priority status
        countyPrioPlayers = {}
        numPlayersInCountyPrio = 0
        countyPrioActive = false
        countyPrioHold = false
        countyPrio = Config.Priorities.County_Priority.TextSettings
                         .StatusMessages.StatusAvailable

        -- Notify players about the reset
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ", "~r~ALERT: ~b~" .. playerName ..
                    ' ~y~has reset the countywide priority system!'
            }
        })
        SimplePrio_Success('SimplePrio  \n', '**→ ' .. playerName ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *This user has reset the countywide priority*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.County_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.County_Priority.Commands
                                   .PrioReset .. '*.')

        -- Send updated priority status to clients
        TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
    elseif countyPrioCooldown then
        -- Notify player about cooldown
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ALERT: ~b~ You cannot reset the system as cooldown is ~g~enabled~b~! Please wait!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. playerName ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *Priority cannot be reset due to cooldown being enabled! (This system was made to catch script bugs)*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands.PrioReset ..
                            '*.')
    else
        -- Handle the case when neither countyPrioActive nor countyPrioHold is true
        -- This might happen if the priority was already reset
        -- Notify player about the status
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ALERT: ~b~Countywide priority system is already reset!"
            }
        })
    end
end

function ResetCityPriority(player)
    local playerName = GetPlayerName(player)

    -- Check if the player has the required permission
    if not IsPlayerAceAllowed(player, Config.Permissions.ResetAcePermissions) then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You lack the permissions required to run this command!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. playerName ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user lacks permissions required to use this command!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.PrioReset ..
                            '*.')
        return
    end

    -- Reset the city priority
    if cityPrioActive or cityPrioHold then
        -- Reset priority status
        cityPrioPlayers = {}
        numPlayersInCityPrio = 0
        cityPrioActive = false
        cityPrioHold = false
        cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages
                       .StatusAvailable

        -- Notify players about the reset
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ALERT: ~b~" .. playerName ..
                    ' ~y~has reset the citywide priority system!'
            }
        })
        SimplePrio_Success('SimplePrio  \n', '**→ ' .. playerName ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *This user has reset the citywide priority*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                               timestamp ..
                               '* \n **→ Command Used: ** */priority ' ..
                               Config.Priorities.City_Priority.Commands
                                   .mainCommand .. ' ' ..
                               Config.Priorities.City_Priority.Commands
                                   .PrioReset .. '*.')

        -- Send updated priority status to clients
        TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
    elseif cityPrioCooldown then
        -- Notify player about cooldown
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ALERT: ~b~ You cannot reset the system as cooldown is ~g~enabled~b~! Please wait!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. playerName ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *Priority cannot be reset due to cooldown being enabled! (This system was made to catch script bugs)*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.PrioReset ..
                            '*.')
    else
        -- Handle the case when neither cityPrioActive nor cityPrioHold is true
        -- This might happen if the priority was already reset
        -- Notify player about the status
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ALERT: ~b~Citywide priority system is already reset!"
            }
        })
    end
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--                    Priority on Hold Function                      --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

function ToggleCountyPriorityHold(player)
    if IsPlayerAceAllowed(player, Config.Permissions.OnHoldAcePermission) then
        if countyPrioCooldown then
            TriggerClientEvent("chat:addMessage", player, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "~w~[~b~SimplePrio~w~]  ",
                    "~r~ERROR: ~b~You cannot put county priorities on hold due to cooldown!"
                }
            })
        elseif countyPrioHold == true then
            countyPrioHold = false
            countyPrio = Config.Priorities.County_Priority.TextSettings
                             .StatusMessages.StatusAvailable
            TriggerClientEvent("chat:addMessage", -1, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "~w~[~b~SimplePrio~w~]  ",
                    "~r~ALERT: ~b~" .. GetPlayerName(player) ..
                        ' ~y~has ~r~disabled~y~ county priorities being on hold!'
                }
            })
            SimplePrio_Success('SimplePrio  \n',
                               '**→ ' .. GetPlayerName(player) ..
                                   ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Countywide Priorities have been disabled!*\n **→ Priority System (City / County):** *County*\n **→ Hold Status:** *Disabled*\n \n**→ Time command was executed:** *' ..
                                   timestamp ..
                                   '* \n **→ Command Used: ** */priority ' ..
                                   Config.Priorities.County_Priority.Commands
                                       .mainCommand .. ' ' ..
                                   Config.Priorities.County_Priority.Commands
                                       .PrioOnHold .. '*.')
        else
            countyPrioHold = true
            countyPrio = Config.Priorities.County_Priority.TextSettings
                             .StatusMessages.StatusOnHold
            TriggerClientEvent("chat:addMessage", -1, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "~w~[~b~SimplePrio~w~]  ",
                    "~r~ALERT: ~b~" .. GetPlayerName(player) ..
                        ' ~y~has ~g~enabled~y~ county priorities being on hold!'
                }
            })
            SimplePrio_Success('SimplePrio  \n',
                               '**→ ' .. GetPlayerName(player) ..
                                   ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Countywide Priorities have been enabled!*\n **→ Priority System (City / County):** *County*\n **→ Hold Status:** *Enabled*\n \n**→ Time command was executed:** *' ..
                                   timestamp ..
                                   '* \n **→ Command Used: ** */priority ' ..
                                   Config.Priorities.County_Priority.Commands
                                       .mainCommand .. ' ' ..
                                   Config.Priorities.County_Priority.Commands
                                       .PrioOnHold .. '*.')
        end
        TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
        countyPrioPlayers = {}
        numPlayersInCountyPrio = 0
    else
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You lack the permissions required to run this command!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user lacks permissions required to use this command!*\n **→ Priority System (City / County):** *County*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.County_Priority.Commands
                                .mainCommand .. ' ' ..
                            Config.Priorities.County_Priority.Commands
                                .PrioOnHold .. '*.')
    end
end

function ToggleCityPriorityHold(player)
    if IsPlayerAceAllowed(player, Config.Permissions.OnHoldAcePermission) then
        if cityPrioCooldown then
            TriggerClientEvent("chat:addMessage", player, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "~w~[~b~SimplePrio~w~]  ",
                    "~r~ERROR: ~b~You cannot put city priorities on hold due to cooldown!"
                }
            })
        elseif cityPrioHold == true then
            cityPrioHold = false
            cityPrio = Config.Priorities.City_Priority.TextSettings
                           .StatusMessages.StatusAvailable
            TriggerClientEvent("chat:addMessage", -1, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "~w~[~b~SimplePrio~w~]  ",
                    "~r~ALERT: ~b~" .. GetPlayerName(player) ..
                        ' ~y~has ~r~disabled~y~ city priorities being on hold!'
                }
            })
            SimplePrio_Success('SimplePrio  \n',
                               '**→ ' .. GetPlayerName(player) ..
                                   ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Citywide Priorities have been disabled!*\n **→ Priority System (City / County):** *City*\n **→ Hold Status:** *Disabled*\n \n**→ Time command was executed:** *' ..
                                   timestamp ..
                                   '* \n **→ Command Used: ** */priority ' ..
                                   Config.Priorities.City_Priority.Commands
                                       .mainCommand .. ' ' ..
                                   Config.Priorities.City_Priority.Commands
                                       .PrioOnHold .. '*.')
        else
            cityPrioHold = true
            cityPrio = Config.Priorities.City_Priority.TextSettings
                           .StatusMessages.StatusOnHold
            TriggerClientEvent("chat:addMessage", -1, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "~w~[~b~SimplePrio~w~]  ",
                    "~r~ALERT: ~b~" .. GetPlayerName(player) ..
                        ' ~y~has ~g~enabled~y~ city priorities being on hold!'
                }
            })
            SimplePrio_Success('SimplePrio  \n',
                               '**→ ' .. GetPlayerName(player) ..
                                   ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Countywide Priorities have been enabled!*\n **→ Priority System (City / County):** *City*\n **→ Hold Status:** *Enabled*\n \n**→ Time command was executed:** *' ..
                                   timestamp ..
                                   '* \n **→ Command Used: ** */priority ' ..
                                   Config.Priorities.City_Priority.Commands
                                       .mainCommand .. ' ' ..
                                   Config.Priorities.City_Priority.Commands
                                       .PrioOnHold .. '*.')
        end
        TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
        cityPrioPlayers = {}
        numPlayersInCityPrio = 0
    else
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "~w~[~b~SimplePrio~w~]  ",
                "~r~ERROR: ~y~You lack the permissions required to run this command!"
            }
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. GetPlayerName(player) ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *This user lacks permissions required to use this command!*\n **→ Priority System (City / County):** *City*\n \n**→ Time command was executed:** *' ..
                            timestamp ..
                            '* \n **→ Command Used: ** */priority ' ..
                            Config.Priorities.City_Priority.Commands.mainCommand ..
                            ' ' ..
                            Config.Priorities.City_Priority.Commands.PrioOnHold ..
                            '*.')
    end
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--                  Statewide Peacetime Function                     --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

RegisterServerEvent('SimplePrio:peacetime:Sync')
AddEventHandler('SimplePrio:peacetime:Sync', function()
    TriggerClientEvent('SimplePrio:peacetime', -1, peacetimeon)
end)

-- Function to send chat message to all players
function SendChatMessage(color, message)
    TriggerClientEvent("chat:addMessage", -1,
                       {color = color, multiline = true, args = message})
end

-- Function to toggle peacetime status
function TogglePeacetime(player)
    local playerName = GetPlayerName(player)
    if peacetimeon then
        SendChatMessage({255, 0, 0}, {
            "~w~[~b~SimplePrio~w~]  ",
            "Peacetime has been ~r~disabled~w~ by ~r~" .. playerName .. "~w~!"
        })
        SimplePrio_Success('SimplePrio  \n', '**→ ' .. playerName ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Statewide Peacetime has been disabled!*\n **→ Peacetime Status:** *Disabled*\n \n**→ Time command was executed:** *' ..
                               timestamp .. '* \n **→ Command Used: ** */' ..
                               Config.Peacetime.Commands.Peacetime .. '*.')
    else
        SendChatMessage({255, 0, 0}, {
            "~w~[~b~SimplePrio~w~]  ",
            "Statewide Priorities have been ~r~reset~w~ because Peacetime has been ~g~enabled~w~ by ~r~" ..
                playerName .. "~w~!"
        })
        SimplePrio_Success('SimplePrio  \n', '**→ ' .. playerName ..
                               ' used SimplePrio!\n ** **→ Successful: ** *True* \n** → Details:** *Statewide Peacetime has been Enabled!*\n **→ Peacetime Status:** *Enabled*\n \n**→ Time command was executed:** *' ..
                               timestamp .. '* \n **→ Command Used: ** */' ..
                               Config.Peacetime.Commands.Peacetime .. '*.')
        if Config.Peacetime.FrameworkSettings.Framework == 'nd' or
            Config.Peacetime.FrameworkSettings.Framework == 'nat' then
            TriggerClientEvent('SimplePrio:CheckJob', -1)
        end
    end
    peacetimeon = not peacetimeon
    TriggerEvent("SimplePrio:peacetime:Sync", peacetimeon)
end

-- Register the peacetime command
RegisterCommand(Config.Peacetime.Commands.Peacetime,
                function(source, args, rawCommand)
    local player = source

    -- Check if the player has permission to use the command
    if not IsPlayerAceAllowed(player, Config.Permissions.PeacetimeAcePermission) then
        SendChatMessage({255, 0, 0}, {
            "~w~[~b~SimplePrio~w~]  ",
            "~r~ERROR: ~y~You lack permissions needed to run this command!"
        })
        SimplePrio_Fail('SimplePrio  \n', '**→ ' .. playerName ..
                            ' used SimplePrio!\n ** **→ Successful: ** *False* \n** → Details:** *User lacks permission to use peacetime!*\n **→ Peacetime Status:** *Disabled*\n \n**→ Time command was executed:** *' ..
                            timestamp .. '* \n **→ Command Used: ** */' ..
                            Config.Peacetime.Commands.Peacetime .. '*.')
        return
    end

    -- Toggle peacetime status
    TogglePeacetime(player)

    ResetPrioritySystems(player)
end)

function ResetPrioritySystems(source)

    -- Reset priority systems
    countyPrioPlayers = {}
    cityPrioPlayers = {}
    numPlayersInCityPrio = 0
    numPlayersInCountyPrio = 0
    countyPrioActive = false
    cityPrioActive = false

    if not peacetimeon then
        cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages
                       .StatusAvailable
        countyPrio = Config.Priorities.County_Priority.TextSettings
                         .StatusMessages.StatusAvailable
    else
        cityPrio = Config.Priorities.City_Priority.TextSettings.StatusMessages
                       .StatusOnHold
        countyPrio = Config.Priorities.County_Priority.TextSettings
                         .StatusMessages.StatusOnHold
    end

    -- Notify clients about the reset county priority
    TriggerClientEvent('SimplePrio:County:ReturnPrio', -1, countyPrio)
    TriggerClientEvent('SimplePrio:City:ReturnPrio', -1, cityPrio)
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--                                                                   --
--                  Logging Functions For Discord                    --
--                                                                   --
------------------------------------------------------------------------
------------------------------------------------------------------------

function SimplePrio_Fail(name, message)
    local content = {
        {
            ["color"] = Config.Logging.County.Embed_Settings.F_WebhookColor,
            ["title"] = "**SimplePrio Usage Alert**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = 'Made by SimpleDevelopments',
                ["icon_url"] = Config.Logging.County.Embed_Settings.FooterIcon
            }
        }
    }

    PerformHttpRequest(Config.Logging.Webhook_Logging,
                       function(err, text, headers) end, 'POST', json.encode({
        username = Config.Logging.County.Embed_Settings.WebhookName,
        avatar_url = Config.Logging.County.Embed_Settings.WebhookPFP,
        embeds = content
    }), {['Content-Type'] = 'application/json'})
end

function SimplePrio_Success(name, message)
    local content = {
        {
            ["color"] = Config.Logging.County.Embed_Settings.S_WebhookColor,
            ["title"] = "**SimplePrio Usage Alert**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = 'Made by SimpleDevelopments',
                ["icon_url"] = Config.Logging.County.Embed_Settings.FooterIcon
            }
        }
    }

    PerformHttpRequest(Config.Logging.Webhook_Logging,
                       function(err, text, headers) end, 'POST', json.encode({
        username = Config.Logging.County.Embed_Settings.WebhookName,
        avatar_url = Config.Logging.County.Embed_Settings.WebhookPFP,
        embeds = content
    }), {['Content-Type'] = 'application/json'})
end
