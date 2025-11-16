fx_version 'cerulean'
game 'gta5'

author 'LoveU'
description 'Simple /vector3 and /vector4 coord copier'
lua54 'yes'

ui_page 'html/index.html'

shared_script 'config/config.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

client_scripts {
    '@ox_lib/init.lua',
    'client/main.lua',
}
