---@diagnostic disable: lowercase-global
if not Core and Core.UseMinigames and GetResourceState('boii_minigames') ~= 'started' then
    return
end

for k, v in pairs(Core.Minigames) do
    if k == 'boii_minigames' then
        if v.SkillCicle then
            handleSkillCircle = function(cb)
                exports['boii_minigames']:key_drop({
                    style = 'default',      -- Style template
                    score_limit = 5,        -- Amount of keys needed for success
                    miss_limit = 5,         -- Amount of keys allowed to miss before fail
                    fall_delay = 1000,      -- Time taken for keys to fall from top to bottom in (ms)
                    new_letter_delay = 2000 -- Time taken to drop a new key in (ms)
                }, function(success)        -- Game callback
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            end
        end

        if v.SkillBar then
            handleSkillBar = function(cb)
                exports['boii_minigames']:skill_bar({
                    style = 'default',        -- Style template
                    icon = 'fa-solid fa-paw', -- Any font-awesome icon; will use template icon if none is provided
                    orientation = 2,          -- Orientation of the bar; 1 = horizontal centre, 2 = vertical right.
                    area_size = 20,           -- Size of the target area in %
                    perfect_area_size = 5,    -- Size of the perfect area in %
                    speed = 0.5,              -- Speed the target area moves
                    moving_icon = true,       -- Toggle icon movement; true = icon will move randomly, false = icon will stay in a static position
                    icon_speed = 3,           -- Speed to move the icon if icon movement enabled; this value is / 100 in the javascript side true value is 0.03
                }, function(success)          -- Game callback
                    if success == 'perfect' then
                        cb(true)
                    elseif success == 'success' then
                        cb(true)
                    elseif success == 'failed' then
                        cb(false)
                    end
                end)
            end
        end
        if v.Hacking then
            handleHacking = function(cb)
                exports['boii_minigames']:chip_hack({
                    style = 'default',   -- Style template
                    loading_time = 8000, -- Total time to complete loading sequence in (ms)
                    chips = 2,           -- Amount of chips required to find
                    timer = 20000        -- Total allowed game time in (ms)
                }, function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            end
        end
        if v.Lockpicking then
            handleLockpicking = function(cb)
                exports['boii_minigames']:safe_crack({
                    style = 'default', -- Style template
                    difficulty = 5     -- Difficuly; This increases the amount of lock a player needs to unlock this scuffs out a little above 6 locks I would suggest to use levels 1 - 5 only.
                }, function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            end
        end
        if v.WireCut then
            handleWireCut = function(cb)
                exports['boii_minigames']:wire_cut({
                    style = 'default', -- Style template
                    timer = 60000      -- Time allowed to complete game in (ms)
                }, function(success)
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            end
        end
        if v.Anagram then
            handleAnagram = function(cb)
                exports['boii_minigames']:anagram({
                    style = 'default',   -- Style template
                    loading_time = 5000, -- Total time to complete loading sequence in (ms)
                    difficulty = 10,     -- Game difficulty refer to `const word_lists` in `html/scripts/anagram/anagram.js`
                    guesses = 5,         -- Amount of guesses until fail
                    timer = 30000        -- Time allowed for guessing in (ms)
                }, function(success)     -- Game callback
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            end
        end
        if v.Memory then
            handleMemory = function(cb)
                exports['boii_minigames']:pincode({
                    style = 'default', -- Style template
                    difficulty = 4,    -- Difficuly; increasing the value increases the amount of numbers in the pincode; level 1 = 4 number, level 2 = 5 numbers and so on // The ui will comfortably fit 10 numbers (level 6) this should be more than enough
                    guesses = 5        -- Amount of guesses allowed before fail
                }, function(success)   -- Game callback
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            end
        end
        if v.Hangman then
            handleHangman = function(cb)
                exports['boii_minigames']:hangman({
                    style = 'default',   -- Style template
                    loading_time = 5000, -- Total time to complete loading sequence in (ms)
                    difficulty = 4,      -- Game difficulty refer to `const hangman_word_lists` in `html/scripts/hangman/hangman.js`
                    guesses = 5,         -- Amount of guesses until fail
                    timer = 30000        -- Time allowed for guessing in (ms)
                }, function(success)     -- Game callback
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            end
        end
        if v.Smash then
            handleSmash = function(cb)
                exports['boii_minigames']:button_mash({
                    style = 'default', -- Style template
                    difficulty = 10    -- Difficulty; increasing the difficulty decreases the amount the notch increments on each keypress making the game harder to complete
                }, function(success)   -- Game callback
                    if success then
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            end
        end
    end
end
