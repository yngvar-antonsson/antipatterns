# Транзакции перед подключением к реплике

В первом окне:

```bash
tarantool init.lua 1
```

Во втором окне:

```bash
tarantool init.lua 2
```

В первом окне:

```lua
box.space.storage:put{'key1', 'value1'}
box.space.storage:put{'key2', 'value2'}
box.space.storage:put{'key3', 'value3'}

box.snapshot()

box.space.storage:put{'key4', 'value4'}
box.space.storage:put{'key5', 'value5'}
```

Завершаем первый Tarantool с помощью ^C

Удаляем xlog'и:
```bash
rm data/1/*.xlog
```

Запускаем Tarantool снова:

```bash
tarantool init.lua 1
```

Во втором окне:

```lua
box.space.storage:select()
```

```yaml
---
- - ['initialised', true]
  - ['key1', 'value1']
  - ['key2', 'value2']
  - ['key3', 'value3']
  - ['key4', 'value4']
  - ['key5', 'value5']
...
```

В первом окне:

```lua
box.space.storage:select()
```

```yaml
---
- - ['initialised', true]
  - ['key1', 'value1']
  - ['key2', 'value2']
  - ['key3', 'value3']
...
```

## Как починить

- Поменять `replication_connect_quorum = 1`
- Повторить с новыми данными (или сделать `rm -rf data` и повторить заново)
