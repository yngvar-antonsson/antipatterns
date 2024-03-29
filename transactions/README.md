# Transactions before connecting to a replica

First tab:

```bash
tarantool init.lua 1
```

Second tab:

```bash
tarantool init.lua 2
```

First tab:

```lua
box.space.storage:put{'key1', 'value1'}
box.space.storage:put{'key2', 'value2'}
box.space.storage:put{'key3', 'value3'}

box.snapshot()

box.space.storage:put{'key4', 'value4'}
box.space.storage:put{'key5', 'value5'}
```

Stop Tarantool with ^C

Remove xlogs:
```bash
rm data/1/*.xlog
```

Start Tarantool again:

```bash
tarantool init.lua 1
```

Second tab:

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

First tab:

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

## How to fix

- Change `replication_connect_quorum = 1`
- Try again with a new data (or remove old data `rm -rf data` and try again)
