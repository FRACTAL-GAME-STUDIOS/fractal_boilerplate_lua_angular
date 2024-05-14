-- https://github.com/Risky-Shot/new_banking/blob/main/new_banking/client/client.lua

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
    
	return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot(0)
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, cache.ped, 0))

	return b, c, e
end

function DoObjectSettingThing(model)
	local settingObject = true
	local heading = GetEntityHeading(cache.ped)
	RequestProp(model)
	local offset = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 1.5, 0.0)
	local object = CreateObjectNoOffset(model, offset.x, offset.y, offset.z, true, true, false)


    SetEntityHeading(object, 0)
    SetEntityAlpha(object, 150)
    SetEntityCollision(object, false, false)
    FreezeEntityPosition(object, true)

	local angle = 5
	while settingObject do
showTextUI([[
	[SCROLL] Change Rotation
	[E] Confirm
	[ARROW LEFT/RIGHT] Increase/Decrease Rotation Angle
	[Q] Cancel
	Angle: ]] .. angle .. '°')
        local hit, hitCoords = RayCastGamePlayCamera(Config.RenderDistance)
        if hit ~= 0 then
			local _, groundZ = GetGroundZFor_3dCoord(hitCoords.x, hitCoords.y, hitCoords.z, false)
			SetEntityCoords(object, hitCoords.x, hitCoords.y, groundZ, false, false, false, true)
			if IsControlJustPressed(0, 241) then -- Scrollup
				heading += angle
				SetEntityHeading(object, heading)
			end
			if IsControlJustPressed(0, 242) then -- Scrolldow
				heading -= angle
				SetEntityHeading(object, heading)
			end
            if IsControlJustPressed(0, 38) then
				settingObject = false
				break
            end
			if IsControlJustPressed(0, 85) then
				settingObject = false
				DeleteEntity(object)
				break
			end
			if IsControlJustPressed(0, 174) then
				angle = angle - 5
			end
			if IsControlJustPressed(0, 175) then
				angle = angle + 5
			end
        end
		Wait(0)
	end

	hideTextUI()

    SetEntityCollision(object, true, true)
    SetEntityAlpha(object, 255, false)
    FreezeEntityPosition(object, true)
    PlaceObjectOnGroundProperly(object)
    return {
        object = object,
        model = model,
        coords = {
            x = GetEntityCoords(object).x,
            y = GetEntityCoords(object).y,
            z = GetEntityCoords(object).z,
            w = heading
        }
    }
end