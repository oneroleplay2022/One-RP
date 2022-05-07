fx_version "cerulean"
game "gta5"

ui_page 'ui/index.html'

server_script {
    'config.lua',
    'server.lua'
}

client_script {
    'config.lua',
    'client.lua'
}

files {
    'ui/index.html',
    'ui/style.css',
    'ui/main.js',
    'ui/images/*.png',
}
shared_script "@cr-core/import.lua"