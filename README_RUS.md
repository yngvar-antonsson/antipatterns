# Топ-5 провальных решений при разработке на Tarantool

Связанные [статья](https://habr.com/ru/companies/vk/articles/672386/) и [доклад](https://www.youtube.com/watch?v=-FBKkyt1NJ0).

## Map-reduce, который убивает

- [Примеры](select/README_RUS.md)
- Ссылки:
    - [space:select](https://www.tarantool.io/en/doc/latest/reference/reference_lua/box_space/select/)
    - [CRUD](https://github.com/tarantool/crud)

## SPOF

- [Примеры](spof/README.md)
- Ссылки:
    - [Vshard-роутер](https://www.tarantool.io/en/doc/latest/reference/reference_rock/vshard/vshard_architecture/#vshard-router)
    - [Кластеры на Cartridge](https://habr.com/ru/company/vk/blog/596241/)

## Неструктурированные данные

- [Примеры](arrays/init.lua)
- Ссылки:
    - [space:format](https://www.tarantool.io/en/doc/latest/reference/reference_lua/box_space/format/)
    - [slab_alloc_factor](https://www.tarantool.io/en/doc/latest/reference/configuration/#confval-slab_alloc_factor)

## Мастер-мастер репликация без триггеров

- [Примеры](master-master/README.md)
- Ссылки:
    - [Мастер-мастер в Tarantool](https://habr.com/ru/company/vk/blog/524476/)
    - [before_replace триггер](https://www.tarantool.io/en/doc/latest/reference/reference_lua/box_space/before_replace/)

## Транзакции перед подключением к реплике

- [Примеры](transactions/README.md)
- Ссылки:
    - [Транзакции](https://www.tarantool.io/en/doc/latest/book/box/atomic/)
    - [Репликация](https://www.tarantool.io/en/doc/latest/book/replication/repl_architecture/)

## Как не допустить проблем?

- Ссылки:
    - [Тестирование](https://habr.com/ru/company/vk/blog/563446/)
    - [Мониторинг](https://habr.com/ru/company/vk/blog/534826/)

## Как установить Tarantool (для запуска примеров)

- Установка на Debian или Ubuntu:
  ```bash
  curl -L https://tarantool.io/fJPRtan/release/2.8/installer.sh | bash
  sudo apt install cartridge-cli
  ```

- Установка на CentOS, Fedora или ALT Linux:
  ```bash
  curl -L https://tarantool.io/fJPRtan/release/2.8/installer.sh | bash
  sudo yum install cartridge-cli
  ```

- Установка на MacOS:
  ```bash
  brew install tarantool
  brew install cartridge-cli
  ```

### Если что-то не работает

Возможно у вас запущен инстанс Tarantool. Завершите его с помощью `pkill -9 tarantool`
