if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()

function Player(source)
    if source then
        return ESX.GetPlayerFromId(source)
    else
        return ESX.GetPlayerData()
    end
end

function GetPlayerData()
    return ESX.GetPlayerData()
end

function GetJob()
    local playerData = ESX.GetPlayerData()
    return playerData.job
end

function GetJobName()
    return GetJob().name
end

function GetJobGrade()
    return GetJob().grade
end

function GetIdentifier()
    local playerData = ESX.GetPlayerData()
    return playerData.identifier
end

function HasJob(jobName)
    return GetJob().name == jobName
end

function HasJobGrade(jobName, minGrade)
    local job = GetJob()
    return job.name == jobName and job.grade >= minGrade
end

function ShowNotification(text)
    ESX.ShowNotification(text)
end

function ServerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb, ...)
end

function ServerCallbackSync(name, ...)
    local result = nil
    ESX.TriggerServerCallback(name, function(data)
        result = data
    end, ...)
    while result == nil do Wait(0) end
    return result
end

function GetPlayersInArea(coords, radius)
    local coords = coords or GetEntityCoords(PlayerPedId())
    local radius = radius or 3.0
    local list = ESX.Game.GetPlayersInArea(coords, radius)
    local players = {}
    for _, player in pairs(list) do
        if player ~= PlayerId() then
            players[#players + 1] = player
        end
    end
    return players
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    -- THROW NEW EXCEPTION - METHOD NOT IMPLEMENTED
end)

local alreadySpawned = false
RegisterNetEvent('esx:onPlayerDeath', function()
    -- THROW NEW EXCEPTION - METHOD NOT IMPLEMENTED
end)

RegisterNetEvent('esx:onPlayerSpawn', function()
    if not alreadySpawned then
        alreadySpawned = true
        return
    end
end)

function ToggleOutfit(shouldApply, outfitData)
    if not outfitData then outfitData = Core.Outfit.Default end

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        if shouldApply then
            local gender = skin.sex
            local outfit = gender == 1 and outfitData.female or outfitData.male
            if not outfit then return end

            TriggerEvent('skinchanger:loadClothes', skin, outfit)
        else
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end
    end)
end

-- Inventory Fallback

Citizen.CreateThread(function()
    Wait(100)

    if InitializeInventory then return InitializeInventory() end -- Already loaded through inventory folder.

    Inventory = {}

    Inventory.Items = {}

    Inventory.Ready = false

    RegisterNetEvent("fractal_boilerplate:setupInventory", function(data)
        Inventory.Items = data.items
        Inventory.Ready = true
    end)
end)
