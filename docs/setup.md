# Getting Started

This guide will walk you through setting up the project and starting development.

## Prerequisites

- [Node.js LTS](https://nodejs.org/en/) installed
- A working FiveM server or environment to load the resource
- `git` for cloning the repository

## Clone the Repository

```bash
git clone <repository-url> fractal_boilerplate_lua_angular
cd fractal_boilerplate_lua_angular
```

Place the cloned folder inside your server `resources` directory if you plan to use it in-game.

## Install Dependencies

All frontend packages live in the `web` folder. Navigate there and install:

```bash
cd web
npm install
```

## Development Workflow

During development you can build and watch for file changes using:

```bash
npm run watch
```

This command generates the Angular build whenever sources change. Restart your resource in-game to load the updates.

If you prefer a browser-based workflow you can also run:

```bash
npm start
```

and open `http://localhost:4200/` to test the interface outside the game.

## Production Build

When you're ready to deploy, create an optimized build with:

```bash
npm run build
```

The output will be placed in `web/dist/` and can be served by the resource defined in `fxmanifest.lua`.

