if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()


------------------------------
-- Basic player data functions
------------------------------

-- Returns the player's identifier.
-- @return: String representing the player's identifier.
function GetIdentifier()
    local playerData = QBCore.Functions.GetPlayerData()
    return playerData.citizenid or ''
end

-- Returns the current player data.
-- @return: Table containing player data.
function GetPlayerData()
    return QBCore.Functions.GetPlayerData()
end

function GetJob()
    return GetPlayerData().job
end

function GetJobName()
    return GetJob().name
end

function GetJobGrade()
    return GetJob().grade.level
end

function GetIdentifier()
    return GetPlayerData().citizenid
end

function HasJob(jobName)
    return GetJobName() == jobName
end

function HasJobGrade(jobName, minGrade)
    return GetJobName() == jobName and GetJobGrade() >= minGrade
end

function ServerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end

function ServerCallbackSync(name, cb, ...)
    local result = nil
    QBCore.Functions.TriggerCallback(name, function(data)
        result = data
    end, ...)
    while result == nil do Wait(0) end
    return result
end

function ShowNotification(text)
    QBCore.Functions.Notify(text)
end

function GetPlayersInArea(coords, radius)
    local coords = coords or GetEntityCoords(PlayerPedId())
    local radius = radius or 3.0
    local list = QBCore.Functions.GetPlayersFromCoords(coords, radius)
    local players = {}
    for _, player in pairs(list) do
        if player ~= PlayerId() then
            players[#players + 1] = player
        end
    end
    return players
end

RegisterNetEvent(GetCurrentResourceName() .. ":showNotification", function(text)
    ShowNotification(text)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    -- THROW NEW EXCEPTION - METHOD NOT IMPLEMENTED
end)

RegisterNetEvent('fractal_boilerplate:SetDeathStatus', function(status)
    if status then
        -- Player died
    else
        -- Player respawned
    end
end)

function ToggleOutfit(shouldApply, outfitData)
    if not outfitData then outfitData = Core.Outfit.Default end
    local gender = QBCore.Functions.GetPlayerData().charinfo.gender

    if shouldApply then
        local outfit = gender == 1 and outfitData.female or outfitData.male
        if not outfit then return end

        TriggerEvent('qb-clothing:client:loadOutfit', { outfitData = outfit })
    else
        TriggerServerEvent("qb-clothes:loadPlayerSkin")
    end
end

function GetConvertedClothes(oldClothes)
    local clothes = {}
    local components = {
        ['arms'] = "arms",
        ['tshirt_1'] = "t-shirt",
        ['torso_1'] = "torso2",
        ['bproof_1'] = "vest",
        ['decals_1'] = "decals",
        ['pants_1'] = "pants",
        ['shoes_1'] = "shoes",
        ['helmet_1'] = "hat",
        ['chain_1'] = "accessory",
    }
    local textures = {
        ['tshirt_1'] = 'tshirt_2',
        ['torso_1'] = 'torso_2',
        ['bproof_1'] = 'bproof_2',
        ['decals_1'] = 'decals_2',
        ['pants_1'] = 'pants_2',
        ['shoes_1'] = 'shoes_2',
        ['helmet_1'] = 'helmet_2',
        ['chain_1'] = 'chain_2',
    }
    for k, v in pairs(oldClothes) do
        local component = components[k]
        if component then
            local texture = textures[k] and (oldClothes[textures[k]] or 0) or 0
            clothes[component] = { item = v, texture = texture }
        end
    end
    return clothes
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
