local clock = require'clock'
local log = require'log'

box.cfg{}

box.schema.space.create('storage1', {if_not_exists = true} )
box.schema.space.create('storage2', {if_not_exists = true} )
box.space.storage1:format({
    {name = 'key', type = 'string'},
    {name = 'value', type = 'any'}, -- [{name: value}, ...]
})

box.space.storage2:format({
    {name = 'key', type = 'string'},
    {name = 'pos', type = 'unsigned'},
    {name = 'name', type = 'string'},
    {name = 'value', type = 'string'},
})

box.space.storage1:create_index('primary', {parts = {{field = 'key'}}, if_not_exists = true})
box.space.storage2:create_index('primary', {parts = {'key', 'pos'}, if_not_exists = true})

local data1 = {}
for i = 1, 1000 do
    data1[i] = {name = (math.random(2) % 2 == 1) and 'name1' or 'name2', value = math.random()}
end


--- INSERT ---

local t = clock.time()
box.space.storage1:put{'key', data1}
t = clock.time() - t

log.info('Storage 1 insert time: %f', t)

local data2 = {}

for i, v in ipairs(data1) do
    data1[i] = {'key', i, v.name, v.value}
end

t = clock.time()
box.begin()
for _, v in ipairs(data2) do
    box.space.storage2:put(v)
end
box.commit()

t = clock.time() - t

log.info('Storage 2 insert time: %f', t)

--- UPDATE ---

t = clock.time()
local tuple = box.space.storage1:get('key')

for i = 1, 1000 do
    local v = tuple.value[i]
    if v.name == 'name2' then
        v.value = v.value + 1
    end
    tuple.value[i] = v
end

box.space.storage1:put(tuple)

t = clock.time() - t

log.info('Storage 1 update time: %f', t)

-- Storage 1 update time: 0.39773

t = clock.time()

box.begin()
for _, v in box.space.storage2:pairs({'key'}) do
    if v.name == 'name2' then
        box.space.storage2:update({v.key, v.pos}, {{'+', 'value', 1}})
    end
end

box.commit()

t = clock.time() - t

log.info('Storage 2 update time: %f', t)

-- Storage 1 update time: 0.00036

os.exit()
