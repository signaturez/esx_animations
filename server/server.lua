ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function addDatabase(identifier)
    local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Sync.execute("INSERT INTO favoriteanimation (`identifier`) VALUES (@identifier)",{['@identifier'] = identifier})
end

function inDatabase(identifier)
    local result = MySQL.Sync.fetchScalar("SELECT * FROM favoriteanimation WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result then
        return true
    end
    return false
end

AddEventHandler( "playerConnecting", function(name)
    local identifier = GetPlayerIdentifiers(source)[1]
    if inDatabase(identifier) then
        print('Här har du Test skiten tack tack tack')
    elseif not inDatabase(identifier) then
	addDatabas(identifier)
	end
end)

RegisterServerEvent('esx_animations:newFavorite')
AddEventHandler('esx_animations:newFavorite', function(lib, dict, scenario)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.execute("UPDATE favoriteanimation SET lib=@lib,animation=@animation,scenario=@scenario WHERE identifier=@identifier", 
		{
			['@identifier'] = identifier, ['@lib'] = lib, ['@animation'] = dict, ['@scenario'] = scenario
		}
	)
end)

ESX.RegisterServerCallback('esx_animations:getFavorite', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]
		MySQL.Async.fetchAll("SELECT * FROM `favoriteanimation` WHERE `identifier` = @identifier",
		{
			['@identifier'] = identifier
		}, function(result)
		local data = {
			lib			= result[1].lib,
			animation	= result[1].animation,
			scenario 	= result[1].scenario
		}
		cb(data)
	end)
end)

RegisterServerEvent('esx_animations:sync')
AddEventHandler('esx_animations:sync', function(target, animationLib, animation, animation2, distans, distans2, height)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('esx_animations:syncTarget', targetPlayer.source, source, animationLib, animation2, distans, distans2, height, spin)
	TriggerClientEvent('esx_animations:syncMe', source, animationLib, animation, distans, distans2)
end)