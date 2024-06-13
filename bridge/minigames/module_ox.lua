---@diagnostic disable: lowercase-global
if not Core and Core.UseMinigames and GetResourceState('ox_lib') ~= 'started' then
    return
end

for k, v in pairs(Core.Minigames) do
    if k == 'ox_lib' then
        if v.SkillCicle then
            handleSkillCircle = function(cb)
                local success = lib.skillCheck({
                        'easy',
                        'easy',
                        {
                            areaSize = 60,
                            speedMultiplier = 2
                        },
                        'hard'
                    },
                    {
                        'w', 'a', 's', 'd'
                    }
                )
                cb(success)
            end
        end
    end
end
