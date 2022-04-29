# SPOF

В данном разделе пример не очень удачной архитектуры приложения со словарями на отдельном инстансе.

Запуск:

```bash
cartridge build
cartridge start -d
cartridge replicasets setup --bootstrap-vshard
```

По адресу http://localhost:8081 доступен WebUI.

Код ролей можно посмотреть в папке `app/roles`.

## Как исправить?

- Назначить роль `app.roles.dictionary` на router

ИЛИ

- Добавить реплик в репликасет dictionary
- Поменять в функции `app.roles.api.`:
  ```lua
  local connection = assert(cartridge_rpc.get_connection('app.roles.dictionary', {leader_only = false}))
  local deps_data = connection:call('select', department_ids)
  ```
- (Опционально) поставить для этого репликасета галочку ALL_RW **или** сделать спейс `box.space.departments` синхронным:
  ```lua
  box.space.departments:alter{is_async = true}
  ```
