# Мастер-мастер репликация без триггеров

В первой вкладке:
```bash
tarantool init.lua 1
```

Во второй вкладке:
```bash
tarantool init.lua 2
```

На обоих инстансах:
```lua
do
    local fiber = require'fiber'
    local now = fiber.time()
    fiber.sleep( math.ceil( now / 10 ) * 10 - now )
    box.space.test:insert({
            math.floor(fiber.time()),
            fiber.time(),
            "Hello"
        })
end
```

Получаем ошибку ```ER_TUPLE_FOUND: Duplicate key exists in unique index "primary" in space "test" with old tuple - [1642282400, 1.64228e+09, "Hello"] and new tuple - [1642282400, 1.64228e+09, "Hello"]```

## Как исправить?

Перед вызовом `box.cfg` добавляем:

```lua
local my_trigger = function(old, new, _, op)
    if new == nil then
        return
    end
    if old == nil then
        return new
    end
    if op == 'INSERT' then
        if new[2] > old[2] then
            return box.tuple.new(new)
        end
        return old
    end
    if new[2] > old[2] then
        return new
    else
        return old
    end
end

box.ctl.on_schema_init(function()
    box.space._space:on_replace(function(_, sp)
        if sp.name == 'test' then
            box.on_commit(function()
                box.space.test:before_replace(my_trigger)
            end)
        end
    end)
end)
```

