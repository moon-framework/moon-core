-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version '1.0.0'
author 'Moon Dev. Team'
description 'A framework that targets performance and optimization.'
repository 'https://github.com/moon-framework'
fx_version 'adamant'
ui_page 'html/index.html'
client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'client/events.lua',
    'client/discord.lua',
    'client/player.lua'
}
server_scripts {
    'server/main.lua',
    'server/commands.lua',
    'server/discord.lua',
    'server/functions.lua',
    'server/callbacks.lua',
    'server/ignore.lua',
    'server/events.lua',
    'server/player.lua'
}
shared_scripts {
    'shared/core.lua'
}

files {
	'html/*.*',
	'html/sound/*.*'
}

games { 'gta5' }

lua54 'yes'
