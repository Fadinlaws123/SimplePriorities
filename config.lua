Config = {}

Config.ToggleVisibility = 'togglepriohud'
Config.EnablePermissionChecking = true 

Config.Reset = {
    ResetCommand = 'resetprio',
    AcePermission = 'staff'
}

Config.PrioOne = {
    Basic = {
        Display_X = 0.169, 
        Display_Y = 0.910, 
        Scale = 0.4, 
        ZoneName = 'County', 
        DefaultStatus = '~g~Available', 
        AcePermission = 'staff', 
        CooldownTimer = 20 
    },
    Text = {
        Prefix = '~c~County Priority Status~w~: ',
        AvailableText = '~g~Available',
        ActiveText = '~y~Active',
        HoldText = '~o~On Hold',
        CooldownText = '~r~Cooldown'
    },
    Commands = {
        Command = 'countyprio',
        Hold = 'hold',
        Available = 'available',
        Cooldown = 'cooldown',
        Active = 'start'
    }
}

Config.PrioTwo = {
    Basic = {
        Display_X = 0.169,
        Display_Y = 0.930,
        Scale = 0.4,
        ZoneName = 'City',
        DefaultStatus = '~g~Available',
        EnablePermChecking = true,
        AcePermission = 'staff',
        CooldownTimer = 20
    },
    Text = {
        Prefix = '~c~City Priority Status~w~: ',
        AvailableText = '~g~Available',
        ActiveText = '~y~Active',
        HoldText = '~o~On Hold',
        CooldownText = '~r~Cooldown'
    },
    Commands = {
        Command = 'cityprio',
        Hold = 'hold',
        Available = 'available',
        Cooldown = 'cooldown',
        Active = 'start'
    }
}

function Notify(msg) -- Chnage yo noti here
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 255, 0, 0 },
        multiline = true,
        args = { "System", msg }
    })
end
