-- You can edit the following options below! Don't touch any other file but this one! --

Config = {} 

Config.ToggleVisibility = 'togglepriohud'

Config.Reset = { -- Ace Permission: "add_ace group.staff prio.reset allow" 
  ResetCity = 'cityreset',
  ResetCounty = 'countyreset',
  ResetGlobal = 'resetprio'
}

Config.CountyPriority = {
  Basic = {
    Display_X = 0.168, 
    Display_Y = 0.870, 
    Scale = 0.45, 
    ZoneName = 'County', 
    DefaultStatus = '~g~Available', 
    CooldownTimer = 20 
  },
  Text = {
    Prefix = '~w~County Priority~w~: ',
    AvailableText = '~g~Available',
    ActiveText = '~y~Active',
    HoldText = '~o~On Hold',
    CooldownText = '~r~Cooldown'
  }
}

Config.CityPriority = {
  Basic = {
    Display_X = 0.168,
    Display_Y = 0.897,
    Scale = 0.45,
    ZoneName = 'City',
    DefaultStatus = '~g~Available',
    CooldownTimer = 20
  },
  Text = {
    Prefix = '~w~City Priority~w~: ',
    AvailableText = '~g~Available',
    ActiveText = '~y~Active',
    HoldText = '~o~On Hold',
    CooldownText = '~r~Cooldown'
  }
}

Config.Peacetime = {
  Basic = {
    Display_X = 0.168,
    Display_Y = 0.769,
    Scale = 0.45,
  },
  Text = {
    Prefix = '~w~State Peacetime~w~: ',
  }
}