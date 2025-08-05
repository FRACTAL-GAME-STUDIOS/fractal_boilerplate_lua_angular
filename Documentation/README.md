# FiveM Lua + Angular Boilerplate

## Overview
This repository provides a starter template for building FiveM resources with a Lua backend and an Angular NUI front-end. It contains bridges for popular frameworks, reusable core utilities, and an example module to help you boot-strap new features quickly.

## Repository Structure
- `bridge/` – Framework adapters exposing ESX, QBCore, inventory and targeting APIs.
- `core/` – Client and server utilities plus shared helpers. The replication system lives here.
- `modules/` – Feature modules; includes an example showcasing NUI interaction.
- `shared/` – Configuration and helper functions available to all scripts.
- `locales/` – Localization dictionaries for UI strings.
- `web/` – Angular application compiled as NUI.
- `Documentation/` – Project documentation.

## Getting Started
1. Clone the repository inside the server's `resources` folder.
2. Configure the desired framework in `bridge` and adjust options in `shared/sh_config.lua`.
3. Build the NUI:
   ```bash
   cd web
   npm install
   npm run build
   ```
4. Start the FiveM server and add the resource name to `server.cfg`.

## Core Synchronization System
The core exposes a lightweight replication layer inspired by Roblox. The server is authoritative and keeps a versioned table of shared states; clients subscribe to states and submit changes with optimistic updates.

### Server API
```lua
SyncServer.register("weather",{type="sunny"})
SyncServer.set("weather",{type="rain"})
```

### Client API
```lua
SyncClient.on("weather",function(data) print(data.type) end)
SyncClient.setServer("weather",{type="cloudy"})
local current=SyncClient.get("weather")
```

Version numbers resolve conflicts: if a client sends an outdated version, the server responds with the canonical state and version.

## Best Practices
- Namespace state names per module: `inventory:weight`, `phone:contacts`, etc.
- Keep payloads small; send only changed fields.
- Validate client updates on the server before rebroadcasting.
- Use `SyncClient.get` for cached reads instead of frequent server calls.

## Contributing
1. Add new modules under `modules/your_module`.
2. Document any public API using the structure described here.
3. Run project checks before pushing:
   ```bash
   npm install --legacy-peer-deps
   npm test
   ```
