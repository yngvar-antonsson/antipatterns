local fio = require'fio'

local instance_id = string.match(arg[1], '^%d+$')
assert(instance_id, 'malformed instance id')

-- This instance's listening port.
local port = 3300 + instance_id
-- Thid instance's working directory.
local workdir = 'data/'..instance_id

if not fio.path.exists('data/') then
    fio.mkdir('data/')
end

if not fio.path.exists(workdir) then
    local ok = fio.mkdir(workdir)
    assert(ok, "Failed to create working directory " .. workdir .. ": ")
end

box.cfg{
    wal_dir=workdir,
    memtx_dir=workdir,

    listen='127.0.0.1:' .. port,
    replication_connect_quorum = 1,
    replication = {'localhost:3301', 'localhost:3302'},
    read_only = instance_id ~= '1',
}

if box.info.ro == false then
    box.schema.space.create('storage', {if_not_exists = true} )
    box.space.storage:format({
        {name = 'key', type = 'string'},
        {name = 'value', type = 'any'},
    })
    box.space.storage:create_index('primary', {parts = {{field = 'key'}}, if_not_exists = true})
    box.space.storage:put{'initialised', true}
end


box.once('bootstrap', function()
    box.schema.user.grant('guest', 'replication')

    box.schema.user.grant('guest', 'write', 'space', 'storage')
    box.schema.user.grant('guest', 'execute', 'universe')
end)


require('console').start()
os.exit()
