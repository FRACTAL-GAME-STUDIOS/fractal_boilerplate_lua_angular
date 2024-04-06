Core = {
    debug = {
        npcs = {
            ['ConeVision'] = false,

            distSpeech = function (npc)
                RegisterCommand("npcSpeech", function(source, args, rawCommand)
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local npcCoords = GetEntityCoords(npc)
                    local distance = #(playerCoords - npcCoords)
                    print(distance)
                end, false)
            end,
        }
    },

    UseTarget = true, -- When set to true, it'll use targeting instead of key-presses to interact.
    NoModelTargeting = true, -- When set to true and using Target, it'll spawn a small invisible prop so you can third-eye when no entity is defined.
    InteractDistance = 2.0, -- Interaction Radius
    RenderDistance = 100.0,

    Marker = { -- This will only be used if enabled, not using target, and no model is defined in the interaction.
        enabled = true,
        id = 2,
        scale = 0.25, 
        color = {255, 255, 255, 127}
    },

    Fonts = {
        EnableCustomFonts = true,
        ForceUniqueFont = true, -- if you want use diferents custom fonts you need set on DrawMissionText like this "!gfx !f MissionAccomplished Deliver the ~b~vehicle~w~ to the warehouse !fx"
        SelectedFont = "MissionAccomplished",
        CustomFonts = {
            "MissionAccomplished",
        },
    },

    GiveKeys = function (veh)
        print("GiveKeys method not implemented.")
    end
}