if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

local PlayerLoaded = false

------------------------------
-- Basic player data functions
------------------------------

--- Returns the player's unique identifier (citizen ID).
---@return string
function GetIdentifier()
    return QBCore.Functions.GetPlayerData().citizenid or ''
end

--- Returns the full player data table.
---@return table
function GetPlayerData()
    return QBCore.Functions.GetPlayerData()
end

----------------------------
-- Job-related functions
----------------------------

--- Returns the player's current job data.
---@return table
function GetJob()
    return QBCore.Functions.GetPlayerData().job or {}
end

--- Returns the player's current job name.
---@return string
function GetJobName()
    return GetJob().name or ''
end

--- Returns the player's current job grade level.
---@return number
function GetJobGrade()
    return GetJob().grade.level or 0
end

--- Checks if the player has a specific job.
---@param jobName string
---@return boolean
function HasJob(jobName)
    return GetJobName() == jobName
end

--- Checks if the player has a job with at least a specific grade level.
---@param jobName string
---@param minGrade number
---@return boolean
function HasJobGrade(jobName, minGrade)
    return GetJobName() == jobName and GetJobGrade() >= minGrade
end

------------------
-- Money functions
------------------

--- Returns the player's current amount of cash.
---@return number
function GetCash()
    return QBCore.Functions.GetPlayerData().money["cash"] or 0
end

--- Returns the player's current bank balance.
---@return number
function GetBank()
    return QBCore.Functions.GetPlayerData().money["bank"] or 0
end

------------------------------
-- Notification functions
------------------------------

--- Shows a notification to the player using QBCore UI.
---@param text string
---@param type string? "primary" | "success" | "error"
function ShowNotification(text, type)
    QBCore.Functions.Notify(text, type or "primary")
end

RegisterNetEvent(GetCurrentResourceName() .. ":showNotification", function(text)
    ShowNotification(text)
end)

----------------------------------------
-- Server callback functions
----------------------------------------

--- Triggers a server callback asynchronously.
---@param name string
---@param cb function
---@param ... any
function ServerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end

--- Triggers a server callback synchronously (waits for result).
---@param name string
---@param ... any
---@return any
function ServerCallbackSync(name, ...)
    local result = nil
    QBCore.Functions.TriggerCallback(name, function(data)
        result = data
    end, ...)
    while result == nil do Wait(0) end
    return result
end

----------------------------------------
-- Nearby player functions
----------------------------------------

--- Returns players within a specified radius around given coordinates.
---@param coords vector3?
---@param radius number?
---@return table
function GetPlayersInArea(coords, radius)
    coords = coords or GetEntityCoords(PlayerPedId())
    radius = radius or 3.0
    local list = QBCore.Functions.GetPlayersFromCoords(coords, radius)
    local players = {}
    for _, player in pairs(list) do
        if player ~= PlayerId() then
            table.insert(players, player)
        end
    end
    return players
end

--------------------------
-- Player event handlers
--------------------------

--- Event triggered when the player is loaded into the game.
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerLoaded = true
end)

--- Event triggered when the player leaves the server or disconnects.
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    PlayerLoaded = false
end)

--- Event triggered when the player's job is updated.
---@param job table
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    local playerData = QBCore.Functions.GetPlayerData()
    playerData.job = job
end)

--- Event for handling player death or respawn.
---@param status boolean
RegisterNetEvent('fractal_boilerplate:SetDeathStatus', function(status)
    PlayerLoaded = not status
end)

-----------------------------------------
-- Outfit system functions
-----------------------------------------

--- Toggles the player's outfit using qb-clothing.
---@param shouldApply boolean
---@param outfitData table?
function ToggleOutfit(shouldApply, outfitData)
    if not outfitData then outfitData = Core.Outfit.Default end

    local gender = QBCore.Functions.GetPlayerData().charinfo.gender -- 0 = male, 1 = female
    local outfit = (gender == 1 and outfitData.female) or outfitData.male

    if not outfit then return end

    if shouldApply then
        TriggerEvent('qb-clothing:client:loadOutfit', { outfitData = outfit })
    else
        TriggerServerEvent("qb-clothes:loadPlayerSkin")
    end
end

--- Converts legacy ESX-style clothing data to QBCore-style.
---@param oldClothes table
---@return table
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

-----------------------------------------
-- Inventory fallback system
-----------------------------------------

--- Initializes fallback inventory if not already handled by another system.
Citizen.CreateThread(function()
    Wait(100)

    -- Already loaded through inventory folder.
    if InitializeInventory then return InitializeInventory() end

    Inventory = {}
    Inventory.Items = {}
    Inventory.Ready = false

    RegisterNetEvent("fractal_boilerplate:setupInventory", function(data)
        Inventory.Items = data.items
        Inventory.Ready = true
    end)
end)

-----------------------------------------
-- Manual player data override
-----------------------------------------

--- Manually overrides the current player data for development or force refresh.
---@param newData table
function UpdatePlayerData(newData)
    QBCore.Functions.GetPlayerData = function()
        return newData
    end
    PlayerLoaded = true
end
