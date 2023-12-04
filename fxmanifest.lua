fx_version "cerulean"
games { "gta5", "rdr3" }
lua54 "yes"

description "Basic Angular & Lua boilerplate"
author "Fractal Game Studios"
version "1.0.0"
repository 'https://github.com/FRACTAL-GAME-STUDIOS/fractal_boilerplate_lua_angular'

ui_page "web/dist/index.html"

client_scripts {
	"client/cl_main.lua",
	"client/cl_utils.lua"
}

server_scripts {
	"server/sv_main.lua"
}

shared_scripts {
	"shared/sh_main.lua"
}

files {
	"web/dist/index.html",
	"web/dist/**/*",
}
