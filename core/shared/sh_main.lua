Language = {}

function Lang(name, ...)
    if name then 
        local str = Language[Core.Language][name]
        if str then 
            return string.format(str, ...)
        else    
            return "ERR_TRANSLATE_"..(name).."_404"
        end
    else
        return "ERR_TRANSLATE_404"
    end
end

function lerp(a, b, t) return a + (b-a) * t end

function v3(coords) return vec3(coords.x, coords.y, coords.z), coords.w end

function contains(table, value, caseSensitive)
    for i = 1, #table do
        if caseSensitive then
            if table[i] == value then
                return true
            end
        else
            if string.lower(table[i]) == string.lower(value) then
                return true
            end
        end
    end
    return false
end

function containsKey(table, key, caseSensitive)
    for k, _ in pairs(table) do
        if caseSensitive then
            if k == key then
                return true
            end
        else
            if string.lower(k) == string.lower(key) then
                return true
            end
        end
    end
    return false
end

function containsType(table, type, typeToFind)
    for _, item in ipairs(table) do
        if item[type] == typeToFind then
            return true
        end
    end
    return false
end



function GetUUID(length)
    local random = math.random
    local template

    if length == 8 then
        template = 'xxxxxxxx'
    elseif length == 16 then
        template = 'xxxxxxxx-xxxx'
    elseif length == 32 then
        template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    elseif length == 64 then
        template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx-xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    else
        template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    end

    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

--- @param number Random number
--- @return number
function GetRandomId(int)
    local random = math.random
    local template = 'xxxxxx'

    return tonumber(string.gsub(template, '[x]', function (c)
        local v = random(0, 0xf)
        return string.format('%x', v)
    end))
end

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local handle, id = initFunc()
        if not handle or handle == -1 then return end

        local isDone = false
        repeat
            coroutine.yield(id)
            isDone, id = moveFunc(handle)
        until not isDone

        disposeFunc(handle)
    end)
end

function GetNearbyVehiclePlates()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local nearbyVehicles = {}

    for vehicle in EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle) do
        if #(GetEntityCoords(vehicle) - playerCoords) < 40000.0 then
            local plate = GetVehicleNumberPlateText(vehicle)
            table.insert(nearbyVehicles, { vehicle = vehicle, plate = plate })
        end
    end

    return nearbyVehicles
end

function splitPrice(price)
    price = tostring(price)
    local formatted = price
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function table.find(tbl, func)
    for index, value in ipairs(tbl) do
        if func(value) then
            return value, index
        end
    end
    return nil
end

function table.stringify(tbl, indentLevel)
    indentLevel = indentLevel or 0
    local indentStr = string.rep(" ", indentLevel)
    local jsonStr = "{\n"

    for k, v in pairs(tbl) do
        local keyStr = indentStr .. "  \"" .. tostring(k) .. "\": "
        local valueStr

        if type(v) == "table" then
            valueStr = table.stringify(v, indentLevel + 2)
        elseif type(v) == "function" then
            valueStr = "\"[Function]\""
        else
            valueStr = "\"" .. tostring(v) .. "\""
        end

        jsonStr = jsonStr .. keyStr .. valueStr .. ",\n"
    end

    jsonStr = jsonStr:sub(1, -3) .. "\n" .. indentStr .. "}"
    return jsonStr
end

function GetVehicleOccupants(vehicle)
    local occupants = {}
    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)

    for seat = -1, maxSeats - 1 do
        local occupant = GetPedInVehicleSeat(vehicle, seat)
        if occupant ~= 0 and IsPedAPlayer(occupant) then
            local playerId = NetworkGetPlayerIndexFromPed(occupant)
            local isDead = IsEntityDead(occupant)
            if not isDead then
                if playerId then
                    local serverId = GetPlayerServerId(playerId)
                    table.insert(occupants, serverId)
                end
            end            
        end
    end

    return occupants
end

local printed = false
function GetVehicleOccupantsByPlate(plate)
    return GetVehicleOccupants(GetVehicleByPlate(plate))
end

function GetVehicleByPlate(plate)
    local nearbyPlates = GetNearbyVehiclePlates()
    for _, v in pairs(nearbyPlates) do
        if string.lower(v.plate) == string.lower(plate) then
            return v.vehicle
        end
    end
    return nil
end

function getDistance(a, b)
    local x, y, z = table.unpack(a)
    local x2, y2, z2 = table.unpack(b)
    return math.sqrt((x - x2)^2 + (y - y2)^2 + (z - z2)^2)
end

function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
end

--- @param text string Text to show
function DrawMissionText(text)
    if not Core.Fonts.EnableCustomFonts then SetTextFont(0) end
    if Core.Fonts.ForceUniqueFont then
        text = "<font face='" .. Core.Fonts.SelectedFont .. "'>" .. text .. "</font>"
    else
        text = string.gsub(text, "!gfx", "<font")
        text = string.gsub(text, "!f (%w+)", " face='%1'>")
        text = string.gsub(text, "!fx", "</font>")
    end

    SetTextProportional(7)
    SetTextScale(0.6, 0.6)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.5, 0.95)
end

function GetInventoryImage(name)
    return ('%s%s%s'):format(Core.InventoryURL, name, Core.InventoryFileExt)
end