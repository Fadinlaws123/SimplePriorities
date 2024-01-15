# SimplePriorities v3

### Version Release 1.0.3

## Change logs:

- _Fixed starting a priority and someone else being able to steal it from you._
- _Fixed not being able to see players in the priority HUD unless it was the client themselves._
- _Fixed Priority cooldown not working._
- _Removed reset functions and replaced it._
- _Updated ace permission functions to better group names._
- _Added peacetime function for staff._
- _Moved HUDs around to fit with [SimpleHUD](https://github.com/Fadinlaws123/SimpleHUD)_
- _Updated City Priority functions to work better._
- _Added chat messages for each command that gets executed._

## Ace Permission Groups:

- Peacetime admin group - "add_ace group.staff pt.admin allow" -- Gives staff the permissions needed to use peacetime
- Priority admin group - "add_ace group.staff prio.admin allow" -- Gives all permissions regarding available status + on hold.

## How to Install:

1. _This resource is very simple to install, all you really need to do is download the latest version from github and then drag and drop the resource into your \resources directory._
2. _Open the config.lua and edit values to your likings._
3. _Open your server.cfg file and add permissions based on what you want people to have, ace groups can be found in the "Ace Permission Group" section above._
4. Restart your server and everything should be working accordingly.

## Side Notes:

- _This resource was created by SimpleDevelopments! If you have any questions, feel free to join our discord and open a ticket, otherwise thank you for using our script!_

## Commands:

### _County Priority Commands_

- _/county-pavail_ ~ Set the priority for the county to be available.
- _/county-pstart_ ~ Start a priority in the county.
- _/county-pcd_ ~ Turn on priority cooldown for the county.
- _/county-hold_ ~ Put all county priorities on hold until further notice.

### _City Priority Commands_

- _/city-pavail_ ~ Set the priority for the city to be available.
- _/city-pstart_ ~ Start a priority in the city.
- _/city-pcd_ ~ Turn on priority cooldown for the city.
- _/city-hold_ ~ Put all city priorities on hold until further notice.
