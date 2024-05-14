if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()

function ShowNotification(text)
	ESX.ShowNotification(text)
end

function ServerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb,  ...)
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
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    -- THROW NEW EXCEPTION - METHOD NOT IMPLEMENTED
end)

local alreadySpawned = false
RegisterNetEvent('esx:onPlayerDeath', function()
    CheckBreakout = false
end)

RegisterNetEvent('esx:onPlayerSpawn', function()
    if not alreadySpawned then
        alreadySpawned = true
        return
    end
end)

function ToggleOutfit(inPrison)
    if inPrison then 
        local prison = Config.Prisons[Prison.index]
        local outfits = prison.outfit or Config.Default.outfit
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            local gender = skin.sex
            local outfit = gender == 1 and outfits.female or outfits.male
            if not outfit then return end
            TriggerEvent('skinchanger:loadClothes', skin, outfit)
        end)
    else
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    end
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