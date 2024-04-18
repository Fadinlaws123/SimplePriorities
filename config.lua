Config = {}

Config.Permissions = {
    PeacetimeAcePermission = "pt.admin", -- Ace permission group required to change peacetime on / off.
    OnHoldAcePermission = "prio.onhold", -- Ace permission group required to change prio to be "on hold".
    CooldownAcePermission = "prio.cooldown", -- Ace permission group required to change prio cooldown.
    ResetAcePermissions = "prio.reset" -- Ace permission group required to change prio to "available".
}

Config.Priorities = {

    PriorityHUD = "togglepriohud", -- Command used to turn on / off the visibility of the hud.

    City_Priority = {

        DisplaySettings = {

            x_location = 0.168, -- X Location that the text will show for the County Priority System.
            y_location = 0.897, -- Y Location that the text will show for the County Priority System.
            TextScale = 0.45 -- Text scale ~ Changes how big / small the County Priority HUD shows.

        },
        Commands = {
            mainCommand = 'city', -- Command to trigger a countywide priority.

            StartPrio = "start", -- Command to set priority for the city active.
            EndPrio = "end", -- Command to stop an active priority in the city.
            JoinPrio = "join", -- Command to join the active priority in the city.
            LeavePrio = "leave", -- Command to leave the active priority in the city.
            PrioOnHold = "hold", -- Command to set Priority for the city on hold.
            PrioCooldown = "cooldown", -- Command to set Priority for the city on cooldown.
            PrioReset = "reset" -- Command to reset the priority system.
        },

        TextSettings = {

            DefaultStatus = "~g~Available",

            StatusMessages = {

                Prefix = "~w~City Priority: ",
                StatusAvailable = "~g~Available",
                StatusActive = "~y~Active",
                StatusOnHold = "~o~On Hold",
                StatusOnCooldown = "~r~Cooldown"

            },

            CooldownSettings = {

                CooldownTimer = 40 -- How long the cooldown timer will last (In minutes.)

            }
        }
    },

    County_Priority = {

        DisplaySettings = {

            x_location = 0.168, -- X Location that the text will show for the County Priority System.
            y_location = 0.870, -- Y Location that the text will show for the County Priority System.
            TextScale = 0.45 -- Text scale ~ Changes how big / small the County Priority HUD shows.

        },

        Commands = {
            mainCommand = 'county', -- Command to trigger a countywide priority.

            StartPrio = "start", -- Command to set priority for the city active.
            EndPrio = "end", -- Command to stop an active priority in the city.
            JoinPrio = "join", -- Command to join the active priority in the city.
            LeavePrio = "leave", -- Command to leave the active priority in the city.
            PrioOnHold = "hold", -- Command to set Priority for the city on hold.
            PrioCooldown = "cooldown", -- Command to set Priority for the city on cooldown.
            PrioReset = "reset" -- Command to reset the priority system.
        },

        TextSettings = {

            DefaultStatus = "~g~Available",

            StatusMessages = {

                Prefix = "~w~County Priority: ",
                StatusAvailable = "~g~Available",
                StatusActive = "~y~Active",
                StatusOnHold = "~o~On Hold",
                StatusOnCooldown = "~r~Cooldown"

            },

            CooldownSettings = {

                CooldownTimer = 40 -- How long the cooldown timer will last (In minutes.)

            }
        }
    }
}

Config.Peacetime = {

    DisplaySettings = {

        Prefix = "~w~State Peacetime: ",

        x_location = 0.168,
        y_location = 0.769,
        TextScale = 0.45

    },

    Commands = {
        Peacetime = "pt" -- Command to enable / disable peacetime.
    },

    FrameworkSettings = {

        Framework = "standalone", -- Framework being used ~ Options: "nd" = ND_Core | "nat" = NAT2K15 | "standalone" = No Framework
        FrameworkName = "framework", -- Name of the framework resource file. (Required for exports to work)

        DepartmentInfo = {

            NAT2K15_Framework = { -- These are the job levels for NAT2K15's Framework. 

                State_Level = "sast_level",
                Police_Level = "lspd_level",
                Sheriff_Level = "bcso_level",
                Civilian_Level = "civ_level",

                Admin_Level = "admin_level"
            },

            ND_Core_Framework = {"SAHP", "BCSO", "LSPD"}
        }
    }
}

Config.Logging = {

    Webhook_Logging = "https://discord.com/api/webhooks/1203315295104540692/BmbR8afaUHu43K_n7qhQw7a-imMgGBHIJIBA3zb5TUcCdY93vwV_R4PCQpBJUGpmoMBt",

    County = {

        Embed_Settings = {
            WebhookName = "SimpleDevelopments",
            WebhookPFP = "https://cdn.discordapp.com/icons/1066225230479101972/88ffeb74a180ed40f5d49278259cbb8e.png?size=2048&format=webp&quality=lossless&width=0&height=320", -- PFP that the webhook will show in discord.
            S_WebhookColor = "65280", -- Color of the successful embed.
            F_WebhookColor = "16711680", -- Color of the failed embed.
            FooterIcon = "https://cdn.discordapp.com/icons/1066225230479101972/88ffeb74a180ed40f5d49278259cbb8e.png?size=2048&format=webp&quality=lossless&width=0&height=320" -- Footer Icon
        }

    },

    City = {

        Embed_Settings = {
            WebhookName = "SimpleDevelopments",
            WebhookPFP = "https://cdn.discordapp.com/icons/1066225230479101972/88ffeb74a180ed40f5d49278259cbb8e.png?size=2048&format=webp&quality=lossless&width=0&height=320", -- PFP that the webhook will show in discord.
            S_WebhookColor = "65280", -- Color of the successful embed.
            F_WebhookColor = "16711680", -- Color of the failed embed.
            FooterIcon = "https://cdn.discordapp.com/icons/1066225230479101972/88ffeb74a180ed40f5d49278259cbb8e.png?size=2048&format=webp&quality=lossless&width=0&height=320" -- Footer Icon
        }

    },

    Peacetime = {

        Embed_Settings = {
            WebhookName = "SimpleDevelopments",
            WebhookPFP = "https://cdn.discordapp.com/icons/1066225230479101972/88ffeb74a180ed40f5d49278259cbb8e.png?size=2048&format=webp&quality=lossless&width=0&height=320", -- PFP that the webhook will show in discord.
            S_WebhookColor = "65280", -- Color of the successful embed.
            F_WebhookColor = "16711680", -- Color of the failed embed.
            FooterIcon = "https://cdn.discordapp.com/icons/1066225230479101972/88ffeb74a180ed40f5d49278259cbb8e.png?size=2048&format=webp&quality=lossless&width=0&height=320" -- Footer Icon
        }

    }
}
