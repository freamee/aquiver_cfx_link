fx_version 'adamant'

game 'gta5'

version "1.0.2"

lua54 "yes"

escrow_ignore {
    "**.lua"
}

-- provide 'aquiver_cfx_link'

shared_scripts {

}

client_scripts {
    "client/GameCursor.lua"
}

server_scripts {
    "links/frameworks/esx/server.lua",
    "links/frameworks/qbcore/server.lua",
    "links/frameworks/qbox/server.lua",

    "links/inventories/ox_inventory/server.lua",

    "server/exports.lua"
}

files {
    "client/**.lua"
}


--[[
1.0.1:
    - Quasar inventory support
    - On resource start it prints out the recognized framework & inventory

1.0.2:
    - You can now disable the cursor keybind registering in the `config.lua` file.

]]
