fx_version 'cerulean'
game 'gta5'
version '1.0.0'

ui_page 'html/ui.html'

client_scripts {
    '@vrp/lib/utils.lua',
    '@vrp/client/Tunnel.lua',
    '@vrp/client/Proxy.lua',
    'client.lua'
}

server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}

files {
    'html/ui.html',
    'html/design.css'
}