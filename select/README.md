# Map-reduce, который убивает

## Опасности select

```bash
tarantool
```

```lua
box.cfg{memtx_memory = 2*1024*1024*1024}
```

```lua
clock = require'clock'
t = clock.time() box.space.test:select() t = clock.time() - t
```

## Пагинация с офсетом

```lua
clock = require'clock'
t = clock.time()
for i = 0, 200 do
    box.space.test:pairs():drop_n(1000 * i):take_n(1000):totable()
end
t = clock.time() - t
```
t = 22s

```lua
t = clock.time()
last_key = nil
for i = 0, 200 do
    res = box.space.test:pairs(last_key, { iterator = 'GE' }):take_n(1000):totable()
    last_key = res[1000][0]
end
t = clock.time() - t
```
t = 0.1s
