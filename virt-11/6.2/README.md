# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```
mikhailrusakovich@Mikhails-MacBook-Pro 6.2 % docker volume create volume01
mikhailrusakovich@Mikhails-MacBook-Pro 6.2 % docker volume create volume02
mikhailrusakovich@Mikhails-MacBook-Pro 6.2 % docker run --rm -d --name pg-docker -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v volume01:/var/lib/postgresql/data -v volume02:/var/lib/postgresql/data postgres:12
mikhailrusakovich@Mikhails-MacBook-Pro 0 % docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh
/ # 
/ # ls -lah /var/lib/docker/volumes/
total 40K    
drwx-----x    4 root     root        4.0K Nov 28 21:19 .
drwx--x--x   13 root     root        4.0K Nov 28 21:09 ..
brw-------    1 root     root      254,   1 Nov 28 21:09 backingFsBlockDev
-rw-------    1 root     root       32.0K Nov 28 21:19 metadata.db
drwx-----x    3 root     root        4.0K Nov 28 21:19 volume01
drwx-----x    3 root     root        4.0K Nov 28 21:19 volume02
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,

```
postgres-# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

```

- описание таблиц (describe)

```
postgres=# \d orders
               Table "public.orders"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 id     | integer |           | not null | 
 name   | text    |           |          | 
 price  | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
    "orders_id_key" UNIQUE CONSTRAINT, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)

postgres=# \d clients
                             Table "public.clients"
  Column  |  Type   | Collation | Nullable |               Default               
----------+---------+-----------+----------+-------------------------------------
 id       | integer |           | not null | nextval('clients_id_seq'::regclass)
 lastname | text    |           |          | 
 country  | text    |           |          | 
 order_id | integer |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_of_living" btree (country)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

```
postgres=# SELECT * FROM information_schema.table_privileges WHERE grantee in ('test-admin-user', 'test-simple-user');
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test-simple-user | postgres      | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | postgres      | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | postgres      | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | postgres      | public       | orders     | DELETE         | NO           | NO
 postgres | test-simple-user | postgres      | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | postgres      | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | postgres      | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | postgres      | public       | clients    | DELETE         | NO           | NO
(8 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

```
postgres=# select count(*) from orders;
 count 
-------
     5
(1 row)

postgres=# select count(*) from clients;
 count 
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

```
postgres=# UPDATE clients SET order_id = (select o.id from orders o where o.name = 'Книга') where lastname = 'Иванов Иван Иванович';
UPDATE 1
postgres=# UPDATE clients SET order_id = (select o.id from orders o where o.name = 'Монитор') where lastname = 'Петров Петр Петрович';
UPDATE 1
postgres=# UPDATE clients SET order_id = (select o.id from orders o where o.name = 'Гитара') where lastname = 'Иоганн Себастьян Бах';
UPDATE 1
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```
postgres=# select * from clients where order_id is not null;
 id |       lastname       | country | order_id 
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(3 rows)
```
 
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```
postgres=# explain select * from clients where order_id is not null;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: (order_id IS NOT NULL)
(2 rows)
```
Показывает, что система отфильтровала таблицу по полю order_id и показывает стоимость выборки.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

```
postgres@04e8208565ba:/$ pg_dump test_db > /var/lib/postgresql/data/test_db_dump.sql
mikhailrusakovich@Mikhails-MacBook-Pro 6.2 % docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh
/ # cd /var/lib/docker/volumes/
/var/lib/docker/volumes # ls -al
total 52
drwx-----x    7 root     root          4096 Nov 28 22:40 .
drwx--x--x   13 root     root          4096 Nov 28 21:09 ..
drwx-----x    3 root     root          4096 Nov 28 22:40 0354d93af80496a5198e8c7478a44ebbfddff74a964aeeada66e04f0e435f853
drwx-----x    3 root     root          4096 Nov 28 22:38 63272a9774023966939f54673c73eb0c0be59df2944132783e531b27800f6069
brw-------    1 root     root      254,   1 Nov 28 21:09 backingFsBlockDev
drwx-----x    3 root     root          4096 Nov 28 22:39 c55f9edbadf762a27d4140f78184d5ba0187b76cf9e443785113342a2e34c466
-rw-------    1 root     root         32768 Nov 28 22:40 metadata.db
drwx-----x    3 root     root          4096 Nov 28 21:19 volume01
drwx-----x    3 root     root          4096 Nov 28 21:19 volume02

/var/lib/docker/volumes/volume01/_data # ls -al | grep *.sql
-rw-r--r--    1 999      ping           541 Dec  4 00:46 test_db_dump.sql
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

```
mikhailrusakovich@Mikhails-MacBook-Pro 6.2 % docker run --rm -d --name pg-docker-dump -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v volume01:/var/lib/postgresql/data -v volume02:/var/lib/postgresql/ postgres:12 
3dc78867dc272730f018a9d566a035bcea59dd98a30539e5d80c244b3c64ae81
mikhailrusakovich@Mikhails-MacBook-Pro 6.2 % docker exec -it 3dc78867dc272730f018a9d566a035bcea59dd98a30539e5d80c244b3c64ae81 bashroot@3dc78867dc27:/# su postgres
postgres@3dc78867dc27:/$ psql -U postgres -d test_db -1 -f /var/lib/postgresql/data/test_db_dump.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)
```

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

