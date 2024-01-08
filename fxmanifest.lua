fx_version 'cerulean'
games { 'gta5' }

name 'SimplePriorities'
author 'Fadin_laws'
description 'A simple system to allow priorities in both County AOP + City AOP'
version '1.0.0'

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/versionChecker.lua',
    'server/server.lua'
}

shared_script 'config.lua'