fx_version 'cerulean'
game 'gta5'
version "2.0"
lua54 "yes"

provide {
    'aquiver_cfx_link',
    'aquiver_cfx',
    'aquiver'
}

shared_scripts {
    '@ox_lib/init.lua',
}

dependency 'ox_lib'

client_scripts {
    "main.lua",
    "runtime/client/main.lua"
}

server_scripts {
    "runtime/server/main.lua"
}

files {
    "txd/**",
    "links/**",
    "client/**.lua",
    "shared/**.lua",
    "runtime/client/*.lua"
}
