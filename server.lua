--------------------------
---By NachoASD @2021   ---
---NachoASD#5887       ---
--------------------------

local data
local webhook = ""  -- DiscordWebhook
local image   = ""  -- Imagen

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local discord_webhook = {
    url = webhook,
    image = image
}

function ExtractIdentifiers()
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

RegisterServerEvent('GetPlayerData')
AddEventHandler('GetPlayerData', function()
  local identifier = ExtractIdentifiers()
  MySQL.ready(function ()
  MySQL.Async.fetchAll(
    'SELECT * FROM users WHERE identifier = @identifier',{['@identifier'] = identifier.steam},
    function(result)
    	data = result
    end)
  end)
  TriggerClientEvent("GetPlayerData", source, data)
end)

RegisterNetEvent("asd_fichar:getName")
AddEventHandler("asd_fichar:getName", function()
    local asdIdentifier = ExtractIdentifiers()
    local resultasd = "Null"
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @id",{['@id'] = asdIdentifier.steam}, 
        function(result)
				resultasd = result[1].lastname
				return(resultasd)
		end) 
end)

RegisterNetEvent('asd_fichar:getNamef')
AddEventHandler('asd_fichar:getNamef', function(source)
	local identifiers = ExtractIdentifiers()
	local steam = identifiers.steam
	MySQL.Async.fetchAll("SELECT * FROM `characters` WHERE `identifier` = @id",
	{["@id"] = steam},
	function(result)
		return result[1].lastname
	end)
end)

RegisterServerEvent('asd_fichar:getJob')
AddEventHandler('asd_fichar:getJob',function()
	local source = source 
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayers[i] == source then
			TriggerClientEvent('asd_fichar:setJob',xPlayers[i],xPlayer.job.name)
		end
	end
end)

RegisterServerEvent('asd_fichar:changejob')
AddEventHandler('asd_fichar:changejob', function(_job, _state) -- _Job es el trabajo
	local user = ESX.GetPlayerFromId(source)				   -- _state es el estado: True = On, False = Off
    if _state then
        TriggerClientEvent("SetCount", source, true)
        user.setJob(_job, user.getJob().grade)      
    else
        TriggerClientEvent("SetCount", source, false)
        user.setJob("off".. _job, user.getJob().grade)
	end
end)

RegisterServerEvent('asd_fichar:send')
AddEventHandler('asd_fichar:send',function(author, state, _job, time)
	if state then
		PerformHttpRequest(discord_webhook.url, 
    	function(err, text, header) end, 
    	'POST',    --            El "autor" del mensaje | el usuario |                           El avatar que va a tener el "autor"
		json.encode({username = "asd_fichar・🪐", content = author.. " ha entrado de servicio | ".. _job , avatar_url=discord_webhook.image }), {['Content-Type'] = 'application/json'}) 
	else
		PerformHttpRequest(discord_webhook.url, 
		function(err, text, header) end, 
		'POST',    --            El "autor" del mensaje | el usuario |                           El avatar que va a tener el "autor" 
		json.encode({username = "asd_fichar・🪐", content = author.. " ha salido de servicio | ".. _job.. " Y a estado ".. time.. " segundos" , avatar_url=discord_webhook.image }), {['Content-Type'] = 'application/json'}) 
	end
end)
