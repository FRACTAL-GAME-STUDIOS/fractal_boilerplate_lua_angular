SyncClient = {}
SyncClient.states = {}

RegisterNetEvent("sync:update", function(name, value, version)
    local state = SyncClient.states[name]
    if not state or version > state.version then
        SyncClient.states[name] = {value = value, version = version, onChange = state and state.onChange or nil}
        local change = SyncClient.states[name].onChange
        if change then change(value) end
    end
end)

function SyncClient.get(name)
    local state = SyncClient.states[name]
    if state then
        return state.value
    end
    return nil
end

function SyncClient.on(name, handler)
    local state = SyncClient.states[name] or {value = nil, version = 0}
    state.onChange = handler
    SyncClient.states[name] = state
    TriggerServerEvent("sync:request", name, state.version)
end

function SyncClient.setServer(name, value)
    local state = SyncClient.states[name] or {version = 0}
    state.version = state.version + 1
    SyncClient.states[name] = state
    TriggerServerEvent("sync:clientUpdate", name, value, state.version)
end
