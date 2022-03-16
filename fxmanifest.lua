fx_version 'cerulean'
game 'gta5'

author 'Hiype'
version '1.0.0'

client_scripts {
    "src/RageUI.lua",
	"src/Menu.lua",
	"src/MenuController.lua",
	"src/components/*.lua",
	"src/elements/*.lua",
	"src/items/*.lua",
	"src/panels/*.lua",
	"src/windows/*.lua",
    'client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
}

shared_scripts { 
    'config.lua',
	'lang.lua'
}