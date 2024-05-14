---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function SendAngularMessage(action, data)
	SendNUIMessage({
		action = action,
		data = data
	})
end

local currentResourceName = GetCurrentResourceName()
local debugIsEnabled = GetConvarInt(('%s-debugMode'):format(currentResourceName), 0) == 1 or Core.debug.prints

--- A simple debug print function that is dependent on a convar
--- will output a nice prettified message if debugMode is on
function debugPrint(...)
	if not debugIsEnabled then return end
	local args <const> = { ... }

	local appendStr = ''
	for _, v in ipairs(args) do
		appendStr = appendStr .. ' ' .. tostring(v)
	end
	local msgTemplate = '^3[%s]^0%s'
	local finalMsg = msgTemplate:format(currentResourceName, appendStr)
	print(finalMsg)
end

local isLocked = false
function processRequestExclusive(callback)
	print('Processing request exclusively')
    while isLocked do
        Citizen.Wait(100)
    end
    isLocked = true

    local result = callback()
    isLocked = false
    return result
end

function table.filter(t, fn)
    local ret = {}
    for k, v in pairs(t) do
        if fn(v, k, t) then
            ret[k] = v
        end
    end
    return ret
end
