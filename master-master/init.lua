local fio = require'fio'

local instance_id = string.match(arg[1], '^%d+$')
local port = 3300 + instance_id

if not fio.path.exists('data/') then
    fio.mkdir('data/')
end

local workdir = 'data/'..instance_id
if not fio.path.exists(workdir) then
    local ok = fio.mkdir(workdir)
    assert(ok, "Failed to create working directory " .. workdir .. ": ")
end

box.cfg {
    listen = '127.0.0.1:' .. port,
    replication = {
        'rep:pwd@127.0.0.1:3301',
        'rep:pwd@127.0.0.1:3302',
    },
    wal_dir=workdir,
    memtx_dir=workdir,
}

box.once("schema", function()
   box.schema.user.create('rep', { password = 'pwd' })
   box.schema.user.grant('rep', 'replication') -- grant replication role
   box.schema.space.create("test")
   box.space.test:create_index("primary")
end)

require('console').start()
os.exit()

