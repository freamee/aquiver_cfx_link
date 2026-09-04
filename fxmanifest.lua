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
    "main.lua"
}

server_scripts {

}

shared_scripts {
    '@ox_lib/init.lua',
}

files {
    "txd/**",
    "links/**",
    "client/**.lua",
    "shared/**.lua",
    "shared/**.lua"
}
