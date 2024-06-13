---@diagnostic disable: lowercase-global
if not Core and Core.UseMinigames and GetResourceState('ps-ui') ~= 'started' then
    return
end

for k, v in pairs(Core.Minigames) do
    if k == 'ps-ui' then
        if v.SkillCicle then
            handleSkillCircle = function(cb)
                exports['ps-ui']:Circle(function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end, 2, 20)
            end
        end

        if v.SkillBar then
            handleSkillBar = function(cb)
                exports['ps-ui']:VarHack(function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end, 2, 3)
            end
        end

        if v.Hacking then
            handleHacking = function(cb)
                exports['ps-ui']:Scrambler(function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end, "numeric", 30, 0)
            end
        end

        if v.Laberint then
            handleLaberint = function(cb)
                exports['ps-ui']:Maze(function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end, 20)
            end
        end

        if v.Memory then
            handleMemory = function(cb)
                exports['ps-ui']:Thermite(function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end, 10, 5, 3)
            end
        end
    end
end
