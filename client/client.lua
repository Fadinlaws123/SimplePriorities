local prio1 = Config.PrioOne.Basic.DefaultStatus
local prio2 = Config.PrioTwo.Basic.DefaultStatus
local synced = false
local visible = true

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', Config.PrioOne.Commands.Command, 'Change the priority status for the ' .. Config.PrioOne.Basic.ZoneName, {{ name="Argument", help="" }})
    TriggerEvent('chat:addSuggestion', Config.PrioTwo.Commands.Command, 'Change the priority status for the ' .. Config.PrioTwo.Basic.ZoneName, {{ name="Argument", help="" }})
    if not synced then
        if NetworkIsSessionStarted() then
            TriggerServerEvent('Server:Request:Sync')
            synced = true
        end
    end
end)

RegisterNetEvent('Client:Sync')
AddEventHandler('Client:Sync', function(type, update)
    if type == 'prio1' then
        prio1 = update
    else
        prio2 = update
    end
end)

function DrawHud()
    Citizen.CreateThread(function()
        while visible do
            Draw(Config.PrioOne.Text.Prefix .. '' .. prio1, Config.PrioOne.Basic.Display_X, Config.PrioOne.Basic.Display_Y, Config.PrioOne.Basic.Scale, 4)
            Draw(Config.PrioTwo.Text.Prefix .. '' .. prio2, Config.PrioTwo.Basic.Display_X, Config.PrioTwo.Basic.Display_Y, Config.PrioTwo.Basic.Scale, 4)
            Citizen.Wait(0)
        end
        TerminateThisThread()
    end)
end

DrawHud()

RegisterCommand(Config.ToggleVisibility, function()
    visible = not visible
    DrawHud()
    TriggerEvent('chatMessage', '^3Info^0: Prio HUD toggled.')
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
