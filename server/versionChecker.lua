-- Do not touch anything below here --
local frameworkBrand = "standalone"

if Config.Peacetime.Basic.Framework == 'nd' then 
	frameworkBrand = "ND_Core"
elseif Config.Peacetime.Basic.Framework == 'nat' then
	frameworkBrand = "NAT2K15"
end

local branding = 
[[ 
  //                                                  
  ||
  ||  ____  _                 _      ____       _            _ _   _           
  || / ___|(_)_ __ ___  _ __ | | ___|  _ \ _ __(_) ___  _ __(_) |_(_) ___  ___ 
  || \___ \| | '_ ` _ \| '_ \| |/ _ \ |_) | '__| |/ _ \| '__| | __| |/ _ \/ __|
  ||  ___) | | | | | | | |_) | |  __/  __/| |  | | (_) | |  | | |_| |  __/\__ \
  || |____/|_|_| |_| |_| .__/|_|\___|_|   |_|  |_|\___/|_|  |_|\__|_|\___||___/
  ||                   |_|                                                     
  ||                          Made by Fadin_laws
  ||]]
-- Check for version updates.

Citizen.CreateThread(function()
	local CurrentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
	if not CurrentVersion then
		print('[^1SimplePriorities^0] ^1SimplePriorities failed to check for any updates!')
	end

	function VersionCheckHTTPRequest()
		PerformHttpRequest('https://raw.githubusercontent.com/Fadinlaws123/ScriptVersionChecker/main/SimplePriorities.json', VersionCheck, 'GET')
	end

	function VersionCheck(err, response, headers)
		Citizen.Wait(3000)
		if err == 200 then
			local Data = json.decode(response)
			if CurrentVersion ~= Data.NewestVersion then
				print( branding )			
				print('  ||    \n  ||    SimplePriorities is outdated!')
				print('  ||    Current version: ^2' .. Data.NewestVersion .. '^7')
				print('  ||    Your version: ^1' .. CurrentVersion .. '^7')
				print('  ||    Please download the lastest version from ^5' .. Data.DownloadLocation .. '^7')
				if Data.Changes ~= '' then
					print('  ||    \n  ||    ^5Changes: ^7' .. Data.Changes .. "\n^0  \\\\\n")
				end
			else
				print( branding )			
				print('  ||    ^2SimplePriorities is up to date!!^0')
        		print('  ||    ^3For support, join our discord @ ^5https://discord.gg/mxcu8Az8XG!!^0')
				print('  ||    ^3Framework type selected: ^1' .. frameworkBrand .. '^3!^0')
				if Config.Peacetime.Basic.Framework == 'nd' then
					print('  ||    ^1ND_Core must be version 1.0 in order for this to work! ND_Core update 2.0 does not support job management!^0')
				end
				print('  ||    ^2Your version: ^3' .. CurrentVersion .. '\n^0  ||\n  \\\\\n')
			end
		else
			print( branding )			
			print('  ||    ^1There was an issue attempting to get the latest version info regarding SimplePriorities. If this issue continues contact fadin_laws via Simple Development™️ @ https://discord.gg/mxcu8Az8XG \n^0  ||\n  \\\\\n')
		end
		
		SetTimeout(60000000, VersionCheckHTTPRequest)
	end

	VersionCheckHTTPRequest()
end)