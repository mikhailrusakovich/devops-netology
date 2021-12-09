# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

```
mikhailrusakovich@Mikhails-MacBook-Pro 6.3 % docker volume create volume-mysql
mikhailrusakovich@Mikhails-MacBook-Pro 6.3 % docker run --name some-mysql -v volume-mysql::/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:8.0
7fc8ba8dd022b036243321570200b4d11e561839a513f186f01a060e74233840
mikhailrusakovich@Mikhails-MacBook-Pro 6.3 % docker exec -it some-mysql bash
root@7fc8ba8dd022:/# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 15
Server version: 8.0.27 MySQL Community Server - GPL

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

```
mysql> \s
--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          15
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.27 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 12 min 54 sec

Threads: 2  Questions: 5  Slow queries: 0  Opens: 117  Flush tables: 3  Open tables: 36  Queries per second avg: 0.006
--------------
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

```
mysql> CREATE DATABASE IF NOT EXISTS `test_db`;
Query OK, 1 row affected (0.02 sec)

mysql> USE test_db;
Database changed
mysql> show tables;
Empty set (0.01 sec)
root@557669e17d3a:/var/lib/mysql# mysql test_db -u root -p < test-dump.sql
Enter password: 
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```

**Приведите в ответе** количество записей с `price` > 300.

```
mysql> select count(1) from orders where price > 300;
+----------+
| count(1) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)
```

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```
root@557669e17d3a:/etc/mysql# mysql -u root -p --default-auth=mysql_native_password
Enter password: 
mysql> CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass';
Query OK, 0 rows affected (0.59 sec)

mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.05 sec)
mysql> ALTER USER 'test'@'localhost'
    -> IDENTIFIED BY 'test-pass'
    -> WITH
    -> MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3;
```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

```
mysql> GRANT SELECT ON test_db.* to 'test'@'localhost';
```
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

```
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.02 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.01 sec)
```

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```
mysql> SELECT TABLE_SCHEMA, TABLE_NAME, ENGINE, VERSION  FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'test_db';
+--------------+------------+--------+---------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE | VERSION |
+--------------+------------+--------+---------+
| test_db      | orders     | InnoDB |      10 |
+--------------+------------+--------+---------+
1 row in set (0.01 sec)
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```
mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                           |
+----------+------------+-----------------------------------------------------------------------------------------------------------------+
|        1 | 0.13870100 | SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'test_db'                                          |
|        2 | 0.00793500 | SELECT TABLE_SCHEMA, TABLE_NAME, ENGINE, VERSION  FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'test_db' |
|        3 | 0.00413700 | ALTER TABLE orders ENGINE = MyISAM                                                                              |
|        4 | 0.00506325 | SELECT DATABASE()                                                                                               |
|        5 | 0.05719550 | show databases                                                                                                  |
|        6 | 0.00434025 | show tables                                                                                                     |
|        7 | 0.39433200 | ALTER TABLE orders ENGINE = MyISAM                                                                              |
|        8 | 0.11713700 | ALTER TABLE orders ENGINE = InnoDB                                                                              |
+----------+------------+-----------------------------------------------------------------------------------------------------------------+
8 rows in set, 1 warning (0.01 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

```
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Set IO Speed
# 0 - скорость
innodb_flush_log_at_trx_commit  = 0

# Сжатие таблиц
innodb_file_format=Barracuda

# InnoDB
innodb-buffer-pool-size         = 2048M
innodb-log-file-size            = 100M
innodb_log_buffer_size          = 1M


# Custom config should go here
!includedir /etc/mysql/conf.d/
```
