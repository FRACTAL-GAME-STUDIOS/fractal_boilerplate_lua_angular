fx_version "cerulean"
games { "gta5", "rdr3" }
lua54 "yes"

description "Basic Angular & Lua boilerplate"
author "Fractal Game Studios"
version "1.0.0"
repository 'https://github.com/FRACTAL-GAME-STUDIOS/fractal_boilerplate_lua_angular'

ui_page "web/dist/index.html"
files {
	"web/dist/index.html",
	"web/dist/**/*",
}

client_scripts {
	"bridge/**/**/cl_main.lua",
	"bridge/**/cl_main.lua",
	"bridge/**/module_*.lua",
	
	"core/client/cl_main.lua",
	"core/client/modules/*.lua",
	"core/client/modules/**/*.lua",

	"modules/**/client/cl_main.lua",
	"modules/**/client/cl_utils.lua",
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

	"bridge/**/**/sv_main.lua",
	"bridge/**/sv_main.lua",

	"modules/**/server/sv_main.lua",

	"core/server/sv_main.lua",
	"core/server/modules/*.lua",
	"core/server/modules/**/*.lua",
}

shared_scripts {
	'@ox_lib/init.lua',

	"core/shared/sh_main.lua",
	"core/shared/sh_config.lua",

	"locales/*.lua",

	"modules/**/shared/sh_main.lua",
	"modules/**/shared/sh_*.lua",
	"modules/**/shared/modules/module_*.lua",

	"shared/sh_main.lua",
	"shared/sh_functions.lua"
}


file {
    'stream/**/*.ytyp',
	'web/assets/**/*',
}

data_file 'DLC_ITYP_REQUEST' 'stream/**/*.ytyp'
