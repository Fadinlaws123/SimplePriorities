-- You can edit the following options below! Don't touch any other file but this one! --

Config = {} 

Config.ToggleVisibility = 'togglepriohud'

Config.CountyPriority = {
  Basic = {
    Display_X = 0.168, 
    Display_Y = 0.870, 
    Scale = 0.45, 
    ZoneName = 'County', 
    DefaultStatus = '~g~Available', 
    CooldownTimer = 30 
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
    CooldownTimer = 30
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
    NATFramework_Name = "framework", -- Make sure this matches the resource name for the framework from nat!
    Framework = 'nat', -- Framework being used. "nd" = NDCore | "nat" = NAT2K15 Framework | "standalone" = No Framework
    Display_X = 0.168,
    Display_Y = 0.769,
    Scale = 0.45,
  },
  Text = {
    Prefix = '~w~State Peacetime~w~: ',
  },
  NDCore_Departments = {
    "SAHP",
    "LSPD",
    "BCSO"
  },
  NAT2K15_Settings = { -- These settings only work for NAT2K15's framework!
    
    NAT2K15_Departments = { -- Make sure these match the department levels from the framework departments!
    State_Level = "sast_level",
    Police_Level = "lspd_level",
    Sheriff_Level = "bcso_level",
    Civilian_Level = "civ_level",

    Admin_Level = "admin_level"
    }

  },
}