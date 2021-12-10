# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

```
mikhailrusakovich@Mikhails-MacBook-Pro 6.4 % docker run -d --rm --name pg-docker -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v volume01:/var/lib/postgresql postgres:13
28c7e9d20d8a36f14d860a04ccda89e28aff4eeae1b1764222843e51141cd2c2
mikhailrusakovich@Mikhails-MacBook-Pro 6.4 % docker exec -it pg-docker bash
root@28c7e9d20d8a:/# psql -h localhost -p 5432 -U postgres -W
Password: 
psql (13.5 (Debian 13.5-1.pgdg110+1))
Type "help" for help.

postgres=# \?
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД <br>
\l<br>
- подключения к БД <br>
\conninfo<br>
- вывода списка таблиц <br>
\dt<br>
- вывода описания содержимого таблиц <br>
\d[S+]  NAME <br>
- выхода из psql<br>
\q<br>

## Задача 2

Используя `psql` создайте БД `test_database`.

```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

```
root@28c7e9d20d8a:/var/lib/postgresql# psql -h localhost -U postgres test_database < test-dump.sql
postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)
```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```
postgres=# \c test_database
Password: 
You are now connected to database "test_database" as user "postgres".
test_database=# ANALYZE orders;
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```
test_database=# select tablename, attname, avg_width from pg_stats where tablename = 'orders';
 tablename | attname | avg_width 
-----------+---------+-----------
 orders    | id      |         4
 orders    | title   |        16
 orders    | price   |         4
(3 rows)

test_database=# select max(avg_width) from pg_stats where tablename = 'orders';
 max 
-----
  16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```
test_database=# CREATE TABLE order_price_0_499 (
CHECK ( price <= 499)
)
INHERITS (orders);
CREATE TABLE
test_database=# CREATE TABLE order_price_499_more (
CHECK ( price > 499)
)
INHERITS (orders);
CREATE TABLE
test_database=# \dt
                List of relations
 Schema |         Name         | Type  |  Owner   
--------+----------------------+-------+----------
 public | order_price_0_499    | table | postgres
 public | order_price_499_more | table | postgres
 public | orders               | table | postgres
(3 rows)
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders? <br>

При проектирование и создании БД можно для любой таблицы создать ограничения, триггеры и наследования партицинированных таблиц. 

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```
root@28c7e9d20d8a:/var/lib/postgresql# pg_dump -h localhost -U postgres test_database > my_test_dump.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`? <br>

Например, создать индекс.
```
CREATE UNIQUE INDEX ON orders ((lower(title)));
```