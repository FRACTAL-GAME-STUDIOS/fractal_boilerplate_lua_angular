SyncServer = {}
SyncServer.states = {}

RegisterNetEvent("sync:request", function(name, version)
    local src = source
    local state = SyncServer.states[name]
    if state and state.version > version then
        TriggerClientEvent("sync:update", src, name, state.value, state.version)
    end
end)

RegisterNetEvent("sync:clientUpdate", function(name, value, version)
    local state = SyncServer.states[name]
    if not state or version > state.version then
        SyncServer.states[name] = {value = value, version = version}
        TriggerClientEvent("sync:update", -1, name, value, version)
    else
        TriggerClientEvent("sync:update", source, name, state.value, state.version)
    end
end)

function SyncServer.register(name, initial)
    SyncServer.states[name] = {value = initial, version = 0}
end

function SyncServer.set(name, value)
    local state = SyncServer.states[name]
    if not state then
        SyncServer.register(name, value)
        return
    end
    state.version = state.version + 1
    state.value = value
    TriggerClientEvent("sync:update", -1, name, state.value, state.version)
end
