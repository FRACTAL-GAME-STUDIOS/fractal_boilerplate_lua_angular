if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()
PlayerLoaded = false

------------------------------
-- Basic player data functions
------------------------------

-- Returns the player's identifier.
-- @return: String representing the player's identifier.
function GetIdentifier()
    local playerData = ESX.GetPlayerData()
    return playerData.identifier or ''
end

-- Returns the current player data.
-- @return: Table containing player data.
function GetPlayerData()
    return ESX.GetPlayerData()
end

----------------------------
-- Functions related to work
----------------------------

-- Retrieves the player's job information.
-- @return: Table representing the player's job; returns an empty table if not found.
function GetJob()
    local playerData = ESX.GetPlayerData()
    return playerData.job or {}
end

-- Returns the name of the player's job.
-- @return: String with the job name.
function GetJobName()
    return GetJob().name or ''
end

-- Returns the player's job grade.
-- @return: Number representing the job grade.
function GetJobGrade()
    return GetJob().grade or 0
end

-- Checks if the player has the specified job.
-- @param jobName: String indicating the job to compare.
-- @return: Boolean; true if the player's job matches, false otherwise.
function HasJob(jobName)
    return GetJob().name == jobName
end

-- Checks if the player has the specified job with a minimum grade.
-- @param jobName: String indicating the job name.
-- @param minGrade: Number representing the minimum job grade required.
-- @return: Boolean; true if the player's job matches and grade is >= minGrade, false otherwise.
function HasJobGrade(jobName, minGrade)
    local job = GetJob()
    return job.name == jobName and job.grade >= minGrade
end

------------------
-- Money functions
------------------

-- Returns the accounts associated with the player.
-- @return: Table of player accounts.
function GetAccounts()
    local playerData = ESX.GetPlayerData()
    return playerData.accounts or {}
end

-- Retrieves a specific account by its name.
-- @param accountName: String representing the account name.
-- @return: Account table if found, nil otherwise.
function GetAccount(accountName)
    for _, account in ipairs(GetAccounts()) do
        if account.name == accountName then
            return account
        end
    end
    return nil
end

-- Returns the amount of cash the player has.
-- @return: Number representing cash.
function GetCash()
    local playerData = ESX.GetPlayerData()
    return playerData.money or 0
end

-- Returns the amount of bank money the player has.
-- @return: Number representing bank money.
function GetBank()
    local bankAccount = GetAccount('bank')
    return bankAccount and bankAccount.money or 0
end

---------------------------------
-- Function to show notifications
---------------------------------

-- Displays a notification to the player.
-- @param text: String containing the notification message.
function ShowNotification(text)
    ESX.ShowNotification(text)
end

----------------------------------------
-- Functions for Callbacks to the server
----------------------------------------

-- Triggers a server callback.
-- @param name: String representing the callback event name.
-- @param cb: Function to execute once the server responds.
-- @param ...: Additional parameters to pass to the server callback.
function ServerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb, ...)
end

-- Triggers a server callback synchronously.
-- @param name: String representing the callback event name.
-- @param ...: Additional parameters to pass to the server callback.
-- @return: Data returned by the server callback.
function ServerCallbackSync(name, ...)
    local result = nil
    ESX.TriggerServerCallback(name, function(data)
        result = data
    end, ...)
    while result == nil do Citizen.Wait(0) end
    return result
end

----------------------------------------
-- Function to obtain players in an area
----------------------------------------

-- Retrieves a list of players within a specified area, excluding the current player.
-- @param coords (optional): Coordinates from which to check; defaults to the current player's coordinates.
-- @param radius (optional): Number defining the search radius; defaults to 3.0.
-- @return: Table of player IDs within the specified area.
function GetPlayersInArea(coords, radius)
    local coords = coords or GetEntityCoords(PlayerPedId())
    local radius = radius or 3.0
    local list = ESX.Game.GetPlayersInArea(coords, radius)
    local players = {}
    for _, player in pairs(list) do
        if player ~= PlayerId() then
            table.insert(players, player)
        end
    end
    return players
end

-----------------------------------------
-- Player Event Management
-----------------------------------------

-- Handles the event when a player is loaded.
-- @param xPlayer: Table containing the loaded player data.
-- @param isNew: Boolean indicating if the player is new.
-- @param skin: Table containing the player's skin data.
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    ESX.PlayerData = xPlayer
    PlayerLoaded = NetworkAllocateTunablesRegistrationDataMap
end)

-- Handles the event when a player's job is updated.
-- @param job: Table representing the new job data.
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- Handles the event when the player dies.
-- @param data: Table containing death related data.
RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    PlayerLoaded = false
end)

local alreadySpawned = false
-- Handles the event when the player spawns.
-- No parameters.
RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
    if not alreadySpawned then
        alreadySpawned = true
        return
    end
end)

-- Toggle the player's outfit.
-- @param shouldApply: Boolean indicating whether to apply the new outfit.
-- @param outfitData (optional): Table containing outfit details; defaults to Core.Outfit.Default if not provided.
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

-----------------------------------------
-- Initialization and inventory functions
-----------------------------------------
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

------------------------------------------
-- Function to manually update player data
------------------------------------------

-- Updates the player's data.
-- @param newData: Table containing the updated player data.
function UpdatePlayerData(newData)
    ESX.PlayerData = newData
    PlayerLoaded = true
end
