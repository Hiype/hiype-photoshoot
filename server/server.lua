local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('ss', 'Takes a screenshot', {}, false, function(source, args)
    TriggerClientEvent('hiype-sst:takeScreenshot', source)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    MySQL.insert(string.format("CREATE TABLE IF NOT EXISTS %s (ImageID int AUTO_INCREMENT PRIMARY KEY , image text, citizenid text)", Conf.TableName), function(id) end)
end)

RegisterNetEvent('hiype-sst:saveImage', function(image_link, citizenid)
    MySQL.insert(string.format('INSERT INTO %s (image, citizenid) VALUES ("%s", "%s")', Conf.TableName, image_link, citizenid), function(id)
        print("Image link: " .. tostring(image_link) .. " id:" .. tostring(id))
    end)
end)