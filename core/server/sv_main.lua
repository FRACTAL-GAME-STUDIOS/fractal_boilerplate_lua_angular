--[[--
    Summary: This function is used to get all the vehicles in the server.  
    @return: Returns a table containing all the vehicles in the server.  
]]--
function GetAllVehicles()
    local vehicles = {}
    for vehicle in EnumerateVehicles() do
        table.insert(vehicles, vehicle)
    end
    return vehicles
end

--[[--
    Summary: This function is used to get the plates of all the vehicles in the server.
    @param vehicles: A table containing all the vehicles in the server.
    @return: Returns a table containing the plates of all the vehicles in the server.  
]]--
function GetVehiclePlates(vehicles)
    local vehiclePlates = {}
    for _, vehicle in ipairs(vehicles) do
        local plate = GetVehicleNumberPlateText(vehicle)
        vehiclePlates[vehicle] = plate
    end
    return vehiclePlates
end


--[[--
    Summary: This function is used to get the occupants of all the vehicles in the server.
    @param vehicles: A table containing all the vehicles in the server.
    @return: Returns a table containing the occupants of all the vehicles in the server.  
]]--
function GetVehicleOccupants(vehicles)
    local vehicleOccupants = {}
    for _, vehicle in ipairs(vehicles) do
        local occupants = GetVehicleOccupantList(vehicle)
        vehicleOccupants[vehicle] = occupants
    end
    return vehicleOccupants
end

--[[--
    Summary: This function is used to get a vehicle by its plate.
    @param searchPlate: The plate of the vehicle to search for.
    @return: Returns the vehicle with the specified plate.  
]]--
function GetVehicleByPlate(searchPlate)
    for vehicle in EnumerateVehicles() do
        local plate = GetVehicleNumberPlateText(vehicle)
        if plate == searchPlate then
            return vehicle
        end
    end
    return nil
end

--[[--
    Summary: This function is used to get the occupants of a vehicle.
    @param vehicle: The vehicle to get the occupants of.
    @return: Returns a table containing the occupants of the vehicle.  
]]--
function GetVehicleOccupantList(vehicle)
    local occupants = {}
    for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) do
        local ped = GetPedInVehicleSeat(vehicle, i)
        if ped and DoesEntityExist(ped) then
            table.insert(occupants, ped)
        end
    end
    return occupants
end

--[[--
    Summary: This function is used to get the occupants of a vehicle.
    @param vehicle: The vehicle to get the occupants of.
    @return: Returns a table containing the occupants of the vehicle.  
]]--
function EnumerateVehicles()
    local vehicles = GetAllVehicles() -- Get all vehicles
    local index = 0
    return function()
        index = index + 1
        if index <= #vehicles then
            return vehicles[index]
        else
            return nil
        end
    end
end

--[[--
    Summary: This function is used to get all the details of all the vehicles in the server.
    @return: Returns a table containing all the details of all the vehicles in the server.  
]]--
function GetAllVehicleDetails()
    local allVehicles = GetAllVehicles()
    local allPlates = GetVehiclePlates(allVehicles)
    local allOccupants = GetVehicleOccupants(allVehicles)

    local vehicleDetails = {}

    for _, vehicle in ipairs(allVehicles) do
        table.insert(vehicleDetails, {
            vehicle = vehicle,
            plate = allPlates[vehicle],
            occupants = allOccupants[vehicle]
        })
    end

    return vehicleDetails
end


--[[--
    Summary: This function is used to get the occupants of a vehicle.
    @param vehicle: The vehicle to get the occupants of.
    @return: Returns a table containing the occupants of the vehicle.  
]]--
function asyncSequence(...)
    local functions = {...}
    local index = 1

    local function nextStep(err, result)
        if err then
            print('Error: ' .. err)
            return
        end

        if result then
            print(result)
        end

        local nextFunction = functions[index]
        index = index + 1

        if nextFunction then
            nextFunction(nextStep)
        end
    end

    nextStep()
end

--[[--
    Summary: This function is used to get the occupants of a vehicle.
    @param vehicle: The vehicle to get the occupants of.
    @return: Returns a table containing the occupants of the vehicle.  
]]--
RegisterNetEvent("fractal_boilerplate:server:startEffect")
AddEventHandler("fractal_boilerplate:server:startEffect", function(entity, dict, particleName, off, rot, scale)
    local entity = NetToObj(entity)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    local coords = GetEntityCoords(entity)
    StartNetworkedParticleFxNonLoopedAtCoord(particleName, coords.x + off.x, coords.y + off.y, coords.z + off.z, rot.x, rot.y, rot.z, scale, false, false, false)
end)

RegisterNetEvent("fractal_boilerplate:server:initializePlayer")
AddEventHandler("fractal_boilerplate:server:initializePlayer", function()
    TriggerClientEvent("fractal_boilerplate:client:initializePlayer", source)
end)