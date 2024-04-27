# Top 5 bad decisions when dealing with in-memory databases

Read this [article](https://medium.com/@tarantool/top-5-bad-decisions-when-dealing-with-in-memory-databases-4b2d1fe39317) first.

## Map-reduce, which kills

- [Examples](select/README.md)
- Links:
    - [space:select](https://www.tarantool.io/en/doc/latest/reference/reference_lua/box_space/select/)
    - [CRUD](https://github.com/tarantool/crud)

## SPOF

- [Examples](spof/README.md)
- Links:
    - [Vshard-router](https://www.tarantool.io/en/doc/latest/reference/reference_rock/vshard/vshard_architecture/#vshard-router)
    - [Cartridge clusters](https://dev.to/tarantool/scaling-clusters-without-any-hassle-46in)

## Unstructured data

- [Examples](arrays/init.lua)
- Links:
    - [space:format](https://www.tarantool.io/en/doc/latest/reference/reference_lua/box_space/format/)
    - [slab_alloc_factor](https://www.tarantool.io/en/doc/latest/reference/configuration/#confval-slab_alloc_factor)

## Master-master replication without triggers

- [Examples](master-master/README.md)
- Links:
    - [Мастер-мастер в Tarantool](https://www.tarantool.io/en/doc/latest/concepts/replication/repl_architecture/#replication-roles-master-and-replica)
    - [before_replace trigger](https://www.tarantool.io/en/doc/latest/reference/reference_lua/box_space/before_replace/)

## Transactions before connecting to a replica

- [Examples](transactions/README.md)
- Links:
    - [Transactions](https://www.tarantool.io/en/doc/latest/book/box/atomic/)
    - [Replication](https://www.tarantool.io/en/doc/latest/book/replication/repl_architecture/)

## How to avoid problems?

- Links:
    - [Tests](https://dev.to/tarantool/how-to-write-three-times-fewer-lines-of-code-when-doing-load-testing-9lb)
    - [Monitoring](https://www.tarantool.io/en/doc/latest/book/monitoring/)

## How to install

- Debian/Ubuntu:
  ```bash
  curl -L https://tarantool.io/fJPRtan/release/2.8/installer.sh | bash
  sudo apt install cartridge-cli
  ```

- CentOS/Fedora/ALT Linux:
  ```bash
  curl -L https://tarantool.io/fJPRtan/release/2.8/installer.sh | bash
  sudo yum install cartridge-cli
  ```

- MacOS:
  ```bash
  brew install tarantool
  brew install cartridge-cli
  ```

### If something hasn't worked

Probably you have a running Tarantool instance. Stop it with `pkill -9 tarantool`
