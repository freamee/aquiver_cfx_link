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

files {
    "txd/**",
    "client/**.lua",
    "shared/**.lua"
}
