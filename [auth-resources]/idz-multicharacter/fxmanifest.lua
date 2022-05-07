fx_version 'cerulean'
games { 'gta5' }

author 'IDZ-Scripts [Ido]'
version '1.0.0'

client_script 'multi-cl.lua'
server_script 'multi-se.lua'
shared_scripts {
    'multi-config.lua',
    --'multi-clothes-playerskins.lua',
    'multi-clothes-charactercurrent.lua'
}

escrow_ignore {
    'multi-config.lua',
    --'multi-clothes-playerskins.lua',
    'multi-clothes-charactercurrent.lua',
    'README.md'
}

lua54 "yes"

ui_page 'interface/index.html'

files {
    'interface/index.html',
    'interface/style.css',
    'interface/index.js',
    'interface/font/*',
}