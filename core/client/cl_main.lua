---@diagnostic disable: lowercase-global
local blips = {}
local globalProps = {}

function CreateBlip(data)
    local x,y,z = table.unpack(data.coords)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, data.id or 1)
    SetBlipDisplay(blip, data.display or 4)
    SetBlipScale(blip, data.scale or 1.0)
    SetBlipColour(blip, data.color or 1)
    if (data.rotation) then 
        SetBlipRotation(blip, math.ceil(data.rotation))
    end
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.label)
    EndTextCommandSetBlipName(blip)
    return blip
end

function CreateUniqueBlip(params)
    if not blips[params.id] then
        local blip = nil
        if params.attachEntity then
            blip = AddBlipForEntity(params.attachEntity)
        else
            blip = AddBlipForCoord(params.x, params.y, params.z)
        end

        SetBlipSprite(blip, params.sprite or 1)
        SetBlipDisplay(blip, params.display or 4)
        SetBlipScale(blip, params.scale or 0.5)
        SetBlipColour(blip, params.color or 1)
        SetBlipAsShortRange(blip, params.shortRange or false)

        if params.name then
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(params.name or "")
            EndTextCommandSetBlipName(blip)
        end

        blips[params.id] = blip
    else
        return
    end
end

function DeleteUniqueBlip(id, check)
    check = check or false
    if check and not blips[id] then return end

    if blips[id] then
        RemoveBlip(blips[id])
        blips[id] = nil
    end
end

function GetUniqueBlip(id)
    return blips[id]
end


function CreateMarker(markerData)
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            if markerData.visible() then
                DrawMarker(
                    markerData.type,
                    markerData.coords.x, markerData.coords.y, markerData.coords.z-1.02,
                    markerData.dir.x, markerData.dir.y, markerData.dir.z,
                    0, 0, 0,
                    markerData.scale.x, markerData.scale.y, markerData.scale.z,
                    markerData.color.r, markerData.color.g, markerData.color.b, markerData.color.a,
                    0, 0, 2, 0, 0, 0, 0
                )
            end
        end
    end)
end


function CreateVeh(modelHash, ...)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    local veh = CreateVehicle(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    if Core.GiveKeys then 
        Core.GiveKeys(veh)
    end
    return veh
end

function CreateNPC(modelHash, func, ...)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    local ped = CreatePed(26, modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    if func then func() end

    return ped
end

--[[
    Summary: Creates a ped with a given model hash and a set of options

    @param modelHash: The model hash of the ped
    @param options: A table of options to set on the ped

    Example:
    npcSpeech(entity, {
        distance = npc.speech.distance,
        near = {
            dict_name = npc.speech.near.dict_name,
            speech_name = npc.speech.near.name
        },
        far = {
            dict_name = npc.speech.far.dict_name,
            speech_name = npc.speech.far.name
        }
    })
]]--
function npcSpeech(npc, options)
    if Core.debug.npcs.distSpeech then
        Core.debug.npcs.distSpeech(npc)
    end

    Citizen.CreateThread(function()
        local lastDistance = math.huge

        while true do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local npcCoords = GetEntityCoords(npc)
            local distance = #(playerCoords - npcCoords)

            if GetConeVision(npc, PlayerPedId(), 60.0, 10.0, 90.0) then
                if distance < options.distance then
                    if lastDistance > options.distance then
                        PlayPedAmbientSpeechNative(npc, options.near.name, options.near.dict_name)
                    end
                else
                    if lastDistance < options.distance then
                        PlayPedAmbientSpeechNative(npc, options.far.name, options.far.dict_name)
                    end
                end
            end

            lastDistance = distance
        end
    end)
end

function GetConeVision(npc, entity, viewAngle, viewDistance, rotation)
    local npcCoords = GetEntityCoords(npc)
    local entityCoords = GetEntityCoords(entity)
    local npcHeading = GetEntityHeading(npc)

    local angleToEntity = math.deg(math.atan2(entityCoords.y - npcCoords.y, entityCoords.x - npcCoords.x)) % 360
    local angleDifference = math.abs((npcHeading + rotation) - angleToEntity)
    local isFacingEntity = angleDifference <= viewAngle / 2 or angleDifference >= 360 - viewAngle / 2

    if Core.debug.npcs['ConeVision'] then
        local leftAngle = npcHeading + rotation - (viewAngle / 2)
        local rightAngle = npcHeading + rotation + (viewAngle / 2)
    
        local leftX = npcCoords.x + viewDistance * math.cos(math.rad(leftAngle))
        local leftY = npcCoords.y + viewDistance * math.sin(math.rad(leftAngle))
        local rightX = npcCoords.x + viewDistance * math.cos(math.rad(rightAngle))
        local rightY = npcCoords.y + viewDistance * math.sin(math.rad(rightAngle))
        DrawLine(npcCoords.x, npcCoords.y, npcCoords.z, leftX, leftY, npcCoords.z, 255, 0, 0, 255)
        DrawLine(npcCoords.x, npcCoords.y, npcCoords.z, rightX, rightY, npcCoords.z, 255, 0, 0, 255)
    end

    return isFacingEntity
end

function RequestProp(modelHash)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        debugPrint("Model not loaded, waiting...")
        Wait(0)
    end
    return modelHash
end

function CreateProp(modelHash, ...)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        --debugPrint("Model not loaded, waiting...")
        Wait(0)
    end
    local obj = CreateObject(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)

    globalProps[#globalProps + 1] = obj
    return obj
end

function PlayAnim(ped, dict, ...)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
    TaskPlayAnim(ped, dict, ...)
end

function PlayEffect(dict, particleName, entity, off, rot, scale, networked)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    local off = off or vector3(0.0, 0.0, 0.0)
    local rot = rot or vector3(0.0, 0.0, 0.0)
    local handle = StartParticleFxLoopedOnEntity(particleName, entity, off.x, off.y, off.z, rot.x, rot.y, rot.z, scale or 1.0, false, false, false)
    if networked then 
        TriggerServerEvent("fractal_boilerplate:server:startEffect", ObjToNet(entity), dict, particleName, off, rot, scale)
    end
    return handle
end

function GetClosestVehicleDoor(vehicle, coords)
    local coords = coords or GetEntityCoords(PlayerPedId())
    local bones = {
        "door_dside_f",
        "door_dside_r",
        "door_pside_f",
        "door_pside_r",
        "bonnet",
        "boot"
    }
    local doors = {
        0,
        2,
        1,
        3,
        4,
        5
    }
    local closest
    for i=1, #bones do 
        local boneID = GetEntityBoneIndexByName(vehicle, bones[i])
        if boneID ~= -1 then
            local vcoords = GetWorldPositionOfEntityBone(vehicle, boneID)
            local dist = #(coords - vcoords) 
            if (not closest or closest.dist > dist) and dist < 3.0 then
                closest = {door = doors[i], coords = vcoords, dist = dist}
            end
        end
    end
    if closest then 
        return closest.door, closest.dist
    end
end

function GetNearestEntity(pool, coords, radius, model) 
    local coords = coords or GetEntityCoords(PlayerPedId())
    local radius = radius or 3.0
    local pool = GetGamePool(pool)
    local closest
    for i=1, #pool do 
        local vcoords = GetEntityCoords(pool[i]) 
        local dist = #(coords - vcoords) 
        if (not closest or closest.dist > dist) and (not model or GetEntityModel(pool[i]) == model) then
            closest = {entity = pool[i], dist = dist}
        end
    end
    if closest then 
        return closest.entity, closest.dist
    end
end

function GetNearestVehicle(coords, radius) 
    return GetNearestEntity('CVehicle', coords, radius)
end

function GetNearestEntityModel(model, coords, radius) 
    local entity = GetNearestEntity('CVehicle', coords, radius, model)
    if entity then return entity end
    local entity = GetNearestEntity('CPed', coords, radius, model)
    if entity then return entity end
    local entity = GetNearestEntity('CObject', coords, radius, model)
    if entity then return entity end
end

function GetClosestPlayer(coords, radius)
    local coords = coords or GetEntityCoords(PlayerPedId())
    local radius = radius or 3.0
    local players = GetPlayersInArea(coords, radius)
    local closest
    for i=1, #players do 
        local pcoords = GetEntityCoords(GetPlayerPed(players[i])) 
        local dist = #(coords - pcoords) 
        if not closest or closest.dist > dist then 
            closest = {id = GetPlayerServerId(players[i]), dist = dist}
        end
    end
    if closest then 
        return closest.id, closest.dist
    end
end

local interactTick = 0
local interactCheck = false
local interactText = nil

function ShowInteractText(text)
    if not lib then
        print("OX LIB - NOT LOADED, you need remove comment from fxmanifest.lua")
        return
    end
    local timer = GetGameTimer()
    interactTick = timer
    if interactText == nil or interactText ~= text then 
        interactText = text
        lib.showTextUI(text)
    end
    if interactCheck then return end
    interactCheck = true
    Citizen.CreateThread(function()
        Wait(150)
        local timer = GetGameTimer()
        interactCheck = false
        if timer ~= interactTick then 
            lib.hideTextUI()
            interactText = nil
            interactTick = 0
        end
    end)
end

local Interactions = {}
EnableInteraction = true

function FormatOptions(index, data)
    local options = data.options
    local list = {}
    if not options or #options < 2 then
        list[1] = ((options and options[1]) and options[1] or { label = data.label })
        list[1].name = GetCurrentResourceName() .. "_option_" .. math.random(1,999999999)
        list[1].icon = data.icon
        list[1].onSelect = function(data)
            SelectInteraction(index, 1, data)
        end
        return list
    end
    for i=1, #options do
        list[i] = options[i] 
        list[i].name = GetCurrentResourceName() .. "_option_" .. math.random(1,999999999)
        list[i].icon = data.icon
        list[i].onSelect = function(data)
            SelectInteraction(index, i, data)
        end
    end
    return list
end

function EnsureInteractionModel(index)
    local data = Interactions[index] 
    if not data or data.entity then return end
    local entity
    if not data.model and not data.hiddenKeypress and Core.UseTarget and Core.NoModelTargeting then 
        entity = CreateProp(`ng_proc_brick_01a`, data.coords.x, data.coords.y, data.coords.z, false, true, false)
        SetEntityAlpha(entity, 0, false)
    elseif data.model and (not data.model.modelType or data.model.modelType == "ped") then
        local offset = data.model.offset or vector3(0.0, 0.0, 0.0)
        entity = CreateNPC(data.model.hash, data.coords.x + offset.x, data.coords.y + offset.y, (data.coords.z - 1.0) + offset.z, data.heading, false, true)
        SetEntityInvincible(entity, true)
        SetBlockingOfNonTemporaryEvents(entity, true)
    elseif data.model and data.model.modelType == "prop" then
        local offset = data.model.offset or vector3(0.0, 0.0, 0.0)
        entity = CreateProp(data.model.hash, data.coords.x + offset.x, data.coords.y + offset.y, (data.coords.z - 1.0) + offset.z, false, true, false)
    else
        return
    end
    FreezeEntityPosition(entity, true)
    SetEntityHeading(entity, data.heading)
    Interactions[index].entity = entity
    return entity
end

function DeleteInteractionEntity(index)
    local data = Interactions[index] 
    if not data or not data.entity then return end
    DeleteEntity(data.entity)
    Interactions[index].entity = nil
end

function SelectInteraction(index, selection, targetData)
    if not EnableInteraction then return end
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local data = Interactions[index]

    if not data.target then
        local dist = Vdist(pcoords.x, pcoords.y, pcoords.z, data.coords.x, data.coords.y, data.coords.z)
        if dist > Core.InteractDistance then 
            return ShowNotification(Lang("interact_far"))
        end
    end

    if data.selected then
        data.selected(selection, targetData)
    end
end

function CreateInteraction(data, selected)
    local index
    repeat
        index = math.random(1, 999999999)
    until not Interactions[index]  -- Ensure a unique index

    local options = FormatOptions(index, data)
    Interactions[index] = {
        selected = selected,
        options = options,
        label = data.label,
        model = data.model,
        coords = fixTarget(data.coords, data.fixTarget),
        radius = data.radius or 1.0,
        heading = data.heading,
    }

    if Core and Core.UseTarget then
        Interactions[index].zone = AddTargetZone(Interactions[index].coords, Interactions[index].radius, Interactions[index].options)
    end
    return index
end

function fixTarget(coords, fixTarget)
    if not fixTarget then return coords end
    return vector3(coords.x + fixTarget.x, coords.y + fixTarget.y, coords.z + fixTarget.z)
end

function UpdateInteraction(index, data, selected)
    if not Interactions[index] then return end 
    Interactions[index].selected = selected
    for k,v in pairs(data) do 
        Interactions[index][k] = v
    end
    if data.options then 
        Interactions[index].options = FormatOptions(index, data)
    end
    if Core.UseTarget then
        if Interactions[index].target then 
            RemoveTargetZone(Interactions[index].zone)
            Interactions[index].zone = AddTargetZone(Interactions[index].coords, Interactions[index].radius, Interactions[index].options)
        else
            RemoveModel(Interactions[index].target, Interactions[index].options)
            AddModel(Interactions[index].target, Interactions[index].options)
        end
    end
end

function DeleteInteraction(index)
    local data = Interactions[index] 
    if not data then return end
    if (data.entity) then 
        DeleteInteractionEntity(index)
    end
    if Core.UseTarget then
        if data.target then 
            RemoveTargetModel(data.target, data.options)
        else
            RemoveTargetZone(data.zone)
        end
    end
    Interactions[index] = nil
end

Citizen.CreateThread(function()
    if not lib then
        print("OX LIB - NOT LOADED, you need remove comment from fxmanifest.lua")
        return
    end
    local wait = 5000
    while true do 
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        if #Interactions >= 1 then
            wait = 1500
            for k,v in pairs(Interactions) do 
                local coords = v.coords
                if coords then
                    local dist = Vdist(pcoords.x, pcoords.y, pcoords.z, coords.x, coords.y, coords.z)
                    if (dist < Core.RenderDistance) then 
                        EnsureInteractionModel(k)
                        if not Core.UseTarget or v.hiddenKeypress then
                            if not Core.UseTarget and not v.hiddenKeypress and not v.model and Core.Marker and Core.Marker.enabled then
                                wait = 0
                                DrawMarker(Core.Marker.id, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                                Core.Marker.scale, Core.Marker.scale, Core.Marker.scale, Core.Marker.color[1], 
                                Core.Marker.color[2], Core.Marker.color[3], Core.Marker.color[4], false, true)
                            end
                            if dist < Core.InteractDistance then
                                wait = 0 
                                if not ShowInteractText("[E] - " .. v.label) and IsControlJustPressed(1, 51) then
                                    if not v.options or #v.options < 2 then 
                                        SelectInteraction(k, 1)
                                    else 
                                        lib.registerContext({
                                            id = 'fractal_'..k,
                                            title = v.title or "Options",
                                            options = v.options
                                        })
                                        lib.showContext('fractal_'..k)
                                    end
                                end
                            end
                        end
                    elseif v.entity then
                        DeleteInteractionEntity(k)
                    end
                elseif not Core.UseTarget and v.target then
                    local entity = GetNearestEntityModel(v.target)
                    if entity then
                        local offset = v.offset or vector3(0.0, 0.0, 0.0)
                        local coords = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)
                        local dist = #(pcoords-coords)
                        if dist < v.radius then
                        wait = 0 
                            if not ShowInteractText("[E] - " .. v.label) and IsControlJustPressed(1, 51) then
                                if not v.options or #v.options < 2 then 
                                    SelectInteraction(k, 1, {entity = entity, coords = coords, dist = dist})
                                else 
                                    lib.registerContext({
                                        id = 'fractal_'..k,
                                        title = v.title or "Options",
                                        options = v.options
                                    })
                                    lib.showContext('fractal_'..k)
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)

function emitSound(sound, coords, volume)
    PlaySoundFromCoord(-1, sound, coords.x, coords.y, coords.z, sound, 0, 0, 0)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for k,v in pairs(Interactions) do
        debugPrint("Deleting Interaction: " .. k)
        DeleteInteraction(k)
    end

    for k,v in pairs(globalProps) do
        debugPrint("Deleting Prop: " .. k)
        DeleteEntity(v)
    end

    for k,v in pairs(blips) do 
        debugPrint("Deleting Blip: " .. k)
        RemoveBlip(v)
    end

    SetNuiFocus(false, false)
end)

function progress(message, duration, type)
    if Core.OxProgress then
        if not lib then
            print("OX LIB - NOT LOADED, you need remove comment from fxmanifest.lua")
            return
        end
        if type == 'circle' then
            return lib.progressCircle({
                duration = duration * 1000,
                label = message,
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                    mouse = false
                },
            })
        elseif type == 'default' then
            return lib.progressBar({
                duration = duration * 1000,
                label = message,
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                    mouse = false
                },
            })
        end
    else
        Core.ProgressBar()
    end
    
end

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    Wait(1000)
    TriggerServerEvent("fractal_boilerplate:server:initializePlayer")
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

function loadProp(prop)
    while not HasModelLoaded(prop) do
        RequestModel(prop)
        Wait(0)
    end
end