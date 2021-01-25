--------------------------
---By NachoASD @2020   ---
---NachoASD#5887       ---
--------------------------

author 'NachoASD'
description 'Un script para fichar'
version '1.0.0'

fx_version 'adamant'
game 'gta5'

shared_script 'config.lua'
client_scripts {
    "client.lua",
    '@es_extended/locale.lua'
}
server_scripts {
    "server.lua",
    '@es_extended/locale.lua',
    "@mysql-async/lib/MySQL.lua"
}

dependency 'es_extended'
