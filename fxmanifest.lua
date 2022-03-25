-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version '1.0.0'
author 'Moon Dev. Team'
description 'A framework that targets performance and optimization.'
repository 'https://github.com/moon-framework'
fx_version 'adamant'
client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'client/events.lua'
}
server_scripts {
    'server/main.lua',
    'server/commands.lua',
    'server/functions.lua',
    'server/events.lua'
}
shared_scripts {
    'shared/core.lua'
}

games { 'gta5' }

lua54 'yes'

