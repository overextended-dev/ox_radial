fx_version 'cerulean'
game 'gta5'

author 'overextended-dev'
description ''
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua',
	'locales/de.lua',
	'locales/en.lua',
	'locales/init.lua',
}

client_scripts {
	'trigger.lua',
	'clothing_client.lua',
	'car_client.lua',
	'perso_client.lua',
	'pol_client.lua',
	'frak_client.lua',
}

server_scripts {
    'server.lua',
}

dependencies {	
    'ox_lib',
	'es_extended',
	'ox_inventory',
}