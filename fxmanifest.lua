fx_version 'cerulean'
game 'gta5'

author 'Hiype'
version '2.0.0'

client_scripts {
	'@menuv/menuv.lua',
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/client.lua',
	'client/cam_menu.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua'
}

shared_scripts {
	'@qb-core/shared/locale.lua',
    'config.lua',
	'lang.lua'
}

dependencies {
    'menuv'
}