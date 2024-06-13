---@diagnostic disable: lowercase-global
if not Core and Core.UseMinigames and GetResourceState('glow_minigames') ~= 'started' then
    return
end

for k, v in pairs(Core.Minigames) do
    if k == 'glow_minigames' then

        if v.Laberint then
            handleLaberint = function (cb)
                local settings = {
                    gridSize = 15,
                    ives = 2,
                    timeLimit = 10000
                }

                exports["glow_minigames"]:StartMinigame(function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end, "path", settings)
            end 
        end
        if v.Math then
            handleMath = function (cb)
                exports["glow_minigames"]:StartMinigame(function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end, "math")
            end
        end
        if v.Anagram then
            handleAnagram = function (cb)
                local settings = {
                    gridSize = 6,
                    timeLimit = 8000,
                    charSet = "alphabet",
                    required = 10
                }
                exports["glow_minigames"]:StartMinigame(function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end, "spot", settings)
            end
        end
    end
end