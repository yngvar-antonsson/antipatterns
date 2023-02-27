# SPOF

This directory contains bad exaple of application architecture with dictionaries on a separated instance.

How to start:

```bash
cartridge build
cartridge start -d
cartridge replicasets setup --bootstrap-vshard
```

You will see WebUI on http://localhost:8081.

Roles code is in `app/roles` folder.

## How to fix?

- Select roles `app.roles.dictionary` on router

OR

- Add replicas to dictionary replicaset
- Change function `app.roles.api.get_employees_by_salary`:
  ```lua
  local connection = assert(cartridge_rpc.get_connection('app.roles.dictionary', {leader_only = false}))
  local deps_data = connection:call('select', department_ids)
  ```
- (Optional) add ALL_RW to this replicaset **or** make space `box.space.departments` synchronious:
  ```lua
  box.space.departments:alter{is_sync = true}
  ```
