fx_version "cerulean"
games { "gta5", "rdr3" }
lua54 "yes"

description "Basic Angular & Lua boilerplate"
author "Fractal Game Studios"
version "1.0.0"
repository 'https://github.com/FRACTAL-GAME-STUDIOS/fractal_boilerplate_lua_angular'

ui_page "web/dist/index.html"

client_scripts {
	"bridge/custom/client/cl_main.lua",
	"bridge/esx/client/cl_main.lua",
	"bridge/qbcore/client/cl_main.lua",
	"bridge/inventory/**/cl_main.lua",
	"bridge/target/**/cl_main.lua",

	"core/cl_main.lua",

	"module/**/client/cl_main.lua",
	"module/**/client/cl_utils.lua",
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"bridge/custom/server/sv_main.lua",
	"bridge/esx/server/sv_main.lua",
	"bridge/qbcore/server/sv_main.lua",
	"bridge/inventory/**/sv_main.lua",
	"bridge/target/**/sv_main.lua",

	--"core/sv_main.lua",

	"module/**/server/sv_main.lua",
}

shared_scripts {
	'@ox_lib/init.lua',

	"core/sh_main.lua",

	"module/**/shared/sh_main.lua",

	"shared/sh_main.lua",
	"shared/sh_functions.lua"
}

files {
	"web/dist/index.html",
	"web/dist/**/*",
}
