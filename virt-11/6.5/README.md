# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста

```
#6.5. Elasticsearch
FROM centos:7
LABEL ElasticSearch 6.5
ENV PATH=/usr/lib:/usr/lib/jvm/jre-11/bin:$PATH

RUN yum install java-11-openjdk -y \
    && yum install wget -y 

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.11.1-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.11.1-linux-x86_64.tar.gz.sha512 
RUN yum install perl-Digest-SHA -y 
RUN shasum -a 512 -c elasticsearch-7.11.1-linux-x86_64.tar.gz.sha512 \ 
    && tar -xzf elasticsearch-7.11.1-linux-x86_64.tar.gz \
    && yum upgrade -y
    
ADD elasticsearch.yml /elasticsearch-7.11.1/config/
ENV JAVA_HOME=/elasticsearch-7.11.1/jdk/
ENV ES_HOME=/elasticsearch-7.11.1
RUN groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch
    
RUN mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data \
    && chown -R elasticsearch:elasticsearch /elasticsearch-7.11.1/
RUN mkdir /elasticsearch-7.11.1/snapshots &&\
    chown elasticsearch:elasticsearch /elasticsearch-7.11.1/snapshots
    
USER elasticsearch
CMD ["/elasticsearch-7.11.1/bin/elasticsearch"]
```

- ссылку на образ в репозитории dockerhub
```
https://hub.docker.com/repository/docker/mikhailrusakovich/elasticsearch
```
- ответ `elasticsearch` на запрос пути `/` в json виде

```
mikhailrusakovich@Mikhails-MacBook-Pro 6.5 % curl -GET http://localhost:9200                                           
{
  "name" : "netology_test_node-1",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "sFRhR6SERX6-_WpvLmA44Q",
  "version" : {
    "number" : "7.11.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "ff17057114c2199c9c1bbecc727003a907c0db7a",
    "build_date" : "2021-02-15T13:44:09.394032Z",
    "build_snapshot" : false,
    "lucene_version" : "8.7.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии с таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```buildoutcfg
[elasticsearch@c73431259575 /]$ curl -X GET "localhost:9200/_cat/indices/ind-*?v=true&s=index&pretty"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 jEV215wDRTKCIrkQle3CCw   1   0          0            0       208b           208b
yellow open   ind-2 Aw_mCq_FRpe7xYp7jHB9Ew   2   1          0            0       416b           416b
yellow open   ind-3 HqbaUDnKQTm5i3Ol7l9h_w   4   2          0            0       832b           832b

```

Получите состояние кластера `elasticsearch`, используя API.

```buildoutcfg
[elasticsearch@c73431259575 /]$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 16,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 38.46153846153847
}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.
```buildoutcfg
[elasticsearch@c73431259575 /]$ curl -X DELETE "localhost:9200/ind-1?pretty"
{
  "acknowledged" : true
}
[elasticsearch@c73431259575 /]$ curl -X DELETE "localhost:9200/ind-2?pretty"
{
  "acknowledged" : true
}
[elasticsearch@c73431259575 /]$ curl -X DELETE "localhost:9200/ind-3?pretty"
{
  "acknowledged" : true
}
```
**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.
```buildoutcfg
[elasticsearch@c73431259575 snapshots]$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
> {
>   "type": "fs",
>   "settings": {
>     "location": "/elasticsearch-7.11.1/snapshots",
>     "compress": true
>   }
> }
> '
{
  "acknowledged" : true
}

```
Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```buildoutcfg
[elasticsearch@c73431259575 snapshots]$ curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,  
>       "number_of_replicas": 0
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
[elasticsearch@c73431259575 snapshots]$ curl -X GET "localhost:9200/_cat/indices/test*?v=true&s=index&pretty"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  B7e8Mf8HSH66cUXB090VxQ   1   0          0            0       208b           208b

```
[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

```buildoutcfg
[elasticsearch@c73431259575 snapshots]$ curl -X PUT "localhost:9200/_snapshot/netology_backup/%3Cnetology_backup_%7Bnow%2Fd%7D%3E?pretty"
{
  "accepted" : true
}
```
**Приведите в ответе** список файлов в директории со `snapshot`ами.
```buildoutcfg
[elasticsearch@c73431259575 snapshots]$ ll
total 28
-rw-r--r-- 1 elasticsearch elasticsearch   756 Dec 13 21:03 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Dec 13 21:03 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch  4096 Dec 13 21:03 indices
-rw-r--r-- 1 elasticsearch elasticsearch 10347 Dec 13 21:03 meta-2fee0fh7Tx-9Sq5GhYBzEA.dat
-rw-r--r-- 1 elasticsearch elasticsearch   280 Dec 13 21:03 snap-2fee0fh7Tx-9Sq5GhYBzEA.dat

```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```buildoutcfg
[elasticsearch@c73431259575 snapshots]$ curl -X GET "localhost:9200/_cat/indices/test*?v=true&s=index&pretty"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 nDDvnUsrTfePkTLpKrSO3A   1   0          0            0       208b           208b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
```buildoutcfg
[elasticsearch@c73431259575 elasticsearch-7.11.1]$ curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'
{
  "accepted" : true
}
[elasticsearch@c73431259575 elasticsearch-7.11.1]$ curl -X GET "localhost:9200/_cat/indices/test*?v=true&s=index&pretty"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test   Vf068yYUTHyhnFNJSwJ90A   1   0          0            0       208b           208b
green  open   test-2 8HKjovwISsWy_NpHtcYagA   1   0          0            0       208b           208b
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`