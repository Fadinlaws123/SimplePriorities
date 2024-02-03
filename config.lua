Config = {}

Config.Permissions = {
  PeacetimeAcePermission = "pt.admin", -- Ace permission group required to change peacetime on / off.
  OnHoldAcePermission = "prio.onhold", -- Ace permission group required to change prio to be "on hold".
  CooldownAcePermission = "prio.cooldown", -- Ace permission group required to change prio cooldown.
  ResetAcePermissions = "prio.reset", -- Ace permission group required to change prio to "available".
}

Config.Priorities = {

  PriorityHUD = "togglepriohud", -- Command used to turn on / off the visibility of the hud.

  City_Priority = {

    DisplaySettings = {

      Prefix_Location = { -- Location of the county prio prefix HUD
        x_location = 0.168, -- X Location that the text will show for the County Priority System.
        y_location = 0.897, -- Y Location that the text will show for the County Priority System.
        TextScale = 0.45 -- Text scale ~ Changes how big / small the County Priority HUD shows.
      },

      StatusMessage_Location = { -- Location of the priority status HUD
        x_location = 0.203, -- X Location that the text will show for the County Priority System.
        y_location = 0.897, -- Y Location that the text will show for the County Priority System.
        TextScale = 0.45 -- Text scale ~ Changes how big / small the County Priority HUD shows.
      }

    },

    Commands = {

      StartPrio = "city-pstart", -- Command to set priority for the city active.
      JoinPrio = "city-pjoin", -- Command to join the active priority in the city.
      LeavePrio = "city-pleave", -- Command to leave the active priority in the city.
      PrioEnd = "city-pend", -- Command to stop an active priority in the city.
      PrioAvailable = "city-preset", -- Command to set Priority for the city available.
      PrioOnHold = "city-phold", -- Command to set Priority for the city on hold.
      PrioCooldown = "city-pcd" -- Command to set Priority for the city on cooldown.

    },

    TextSettings = {

      DefaultStatus = "~g~Available",
      ZoneName = "City",

      StatusMessages = {

        Prefix = "~w~City Priority: ",
        StatusAvailable = "~g~Available",
        StatusActive = "~y~Active",
        StatusOnHold = "~o~On Hold",
        StatusOnCooldown = "~r~Cooldown"

      },

      CooldownSettings = {

        CooldownTimer = 30 -- How long the cooldown timer will last (In minutes.)

      }
    }
  },

  County_Priority = {

    DisplaySettings = {

      Prefix_Location = { -- Location of the county prio prefix HUD
        x_location = 0.168, -- X Location that the text will show for the County Priority System.
        y_location = 0.870, -- Y Location that the text will show for the County Priority System.
        TextScale = 0.45 -- Text scale ~ Changes how big / small the County Priority HUD shows.
      },

      StatusMessage_Location = { -- Location of the priority status HUD
        x_location = 0.212, -- X Location that the text will show for the County Priority System.
        y_location = 0.870, -- Y Location that the text will show for the County Priority System.
        TextScale = 0.45 -- Text scale ~ Changes how big / small the County Priority HUD shows.
      }

    },

    Commands = {

      StartPrio = "county-pstart", -- Command to set priority for the county active.
      JoinPrio = "county-pjoin", -- Command to join the active priority in the county.
      LeavePrio = "county-pleave", -- Command to leave the active priority in the county.
      PrioEnd = "county-pend", -- Command to stop an active priority in the county.
      PrioAvailable = "county-preset", -- Command to set Priority for the county available.
      PrioOnHold = "county-phold", -- Command to set Priority for the county on hold.
      PrioCooldown = "county-pcd" -- Command to set Priority for the county on cooldown.

    },

    TextSettings = {

      DefaultStatus = "~g~Available",
      ZoneName = "County",

      StatusMessages = {

        Prefix = "~w~County Priority: ",
        StatusAvailable = "~g~Available",
        StatusActive = "~y~Active",
        StatusOnHold = "~o~On Hold",
        StatusOnCooldown = "~r~Cooldown"

      },

      CooldownSettings = {

        CooldownTimer = 30 -- How long the cooldown timer will last (In minutes.)

      }
    }
  }
}

Config.Peacetime = {

  DisplaySettings = {

    Prefix = "~w~State Peacetime: ",

    StatusMessage_Location = {
      x_location = 0.216,
      y_location = 0.769,
      TextScale = 0.45
    },

    Prefix_Location = {
      x_location = 0.168,
      y_location = 0.769,
      TextScale = 0.45
    }
  },

  Commands = {
    Peacetime = "pt" -- Command to enable / disable peacetime.
  },

  FrameworkSettings = {

    Framework = "nat", -- Framework being used ~ Options: "nd" = ND_Core | "nat" = NAT2K15 | "standalone" = No Framework
    FrameworkName = "framework", -- Name of the framework resource file. (Required for exports to work)

    DepartmentInfo = {

      NAT2K15_Framework = { -- These are the job levels for NAT2K15's Framework. 

        State_Level = "sast_level",
        Police_Level = "lspd_level",
        Sheriff_Level = "bcso_level",
        Civilian_Level = "civ_level",

        Admin_Level = "admin_level"
      },

      ND_Core_Framework = {

        "SAHP",
        "BCSO",
        "LSPD"

      }
    }
  }
}

Config.Logging = {
  
  County = {

    StartPriority = "https://discord.com/api/webhooks/",
    StartCooldown = "https://discord.com/api/webhooks/",
    StartOnHold = "https://discord.com/api/webhooks/",
    SystemReset = "https://discord.com/api/webhooks/",
    JoinPriority = "https://discord.com/api/webhooks/",
    LeavePriority = "https://discord.com/api/webhooks/",
    PriorityEnd = "https://discord.com/api/webhooks/"

  },

  City = {

    StartPriority = "https://discord.com/api/webhooks/",
    StartCooldown = "https://discord.com/api/webhooks/",
    StartOnHold = "https://discord.com/api/webhooks/",
    SystemReset = "https://discord.com/api/webhooks/",
    JoinPriority = "https://discord.com/api/webhooks/",
    LeavePriority = "https://discord.com/api/webhooks/",
    PriorityEnd = "https://discord.com/api/webhooks/"

  },

  Peacetime = {

    PeacetimeEnabled = "https://discord.com/api/webhooks/",
    PeacetimeDisabled = "https://discord.com/api/webhooks/",
    PeacetimeInvalidPerms = "https://discord.com/api/webhooks/"
  
  }
}