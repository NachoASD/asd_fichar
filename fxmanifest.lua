--------------------------
---By NachoASD @2021   ---
---NachoASD#5887       ---
--------------------------
fx_version 'cerulean'
game 'gta5'

author 'NachoASD'
description '[ESP] Un script para entrar o salir de servicio en cualquier trabajo [ENG] A script to enter and exit of service in any job'
version '1.2'

client_scripts {
    '@es_extended/locale.lua',
    'locales/es.lua',
    'locales/en.lua',
    'config.lua',
    "client.lua"
}
server_scripts {
    '@es_extended/locale.lua',
    'locales/es.lua',
    'locales/en.lua',
    'config.lua',
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
}

dependency 'es_extended'
