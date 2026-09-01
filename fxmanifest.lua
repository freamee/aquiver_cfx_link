fx_version 'cerulean'
game 'gta5'
version "2.0"
lua54 "yes"

provide {
    'aquiver_cfx_link',
    'aquiver_cfx',
    'aquiver'
}

client_scripts {
    "links/inventories/ox_inventory/client.lua",
    "links/inventories/quasar_inventory/client.lua",
    "links/inventories/one_inventory/client.lua",

    "client_exports.lua"
}

server_scripts {
    "links/frameworks/esx/server.lua",
    "links/frameworks/qbcore/server.lua",
    "links/frameworks/qbox/server.lua",

    "links/inventories/ox_inventory/server.lua",
    "links/inventories/quasar_inventory/server.lua",

    "server/exports.lua"
}

shared_scripts {
    '@ox_lib/init.lua',
}

files {
    "txd/**",
    "client/**.lua",
    "shared/**.lua",
    "shared/**.lua"
}
