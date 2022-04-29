#!/usr/bin/env tarantool

require('strict').on()

-- configure path so that you can run application
-- from outside the root directory
package.setsearchroot()


-- configure cartridge

local cartridge = require('cartridge')

local ok, err = cartridge.cfg({
    roles = {
        'cartridge.roles.vshard-storage',
        'cartridge.roles.vshard-router',
        'cartridge.roles.metrics',
        'app.roles.storage',
        'app.roles.dictionary',
        'app.roles.api',
    },
})

assert(ok, tostring(err))

local metrics = require('cartridge.roles.metrics')
metrics.set_export({
    {
        path = '/metrics',
        format = 'prometheus'
    },
    {
        path = '/health',
        format = 'health'
    }
})
