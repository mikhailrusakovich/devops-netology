
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

https://hub.docker.com/repository/docker/mikhailrusakovich/nginx

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;<br>
Использование Docker контейнеров возможно, но лучше использовать физические машины, потому что необходим наибыстрейший доступ к вычислительным ресурсам.

- Nodejs веб-приложение; <br>
Использование контейнеров возможно и будет оптимальным выбором

- Мобильное приложение c версиями для Android и iOS; <br>
Для этого сценраия подходят виртуальные машины

- Шина данных на базе Apache Kafka; <br>
Apache Kafka позволяет обрабатывать огромные массивы данных, поэтому считаю, что лучше использовать виртуальные машины, но также возможно использование Docker контейнеров

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana; <br>
Elasticsearch использовать виртуальную машину
logstash и kibana можно развернуть либо на виртуальных машинах либо в контейнерах

- Мониторинг-стек на базе Prometheus и Grafana; <br>
здесь будет удобно и продуктивно использовать Docker контейнеры


- MongoDB, как основное хранилище данных для java-приложения; <br>
виртуальные машины, потому что контейнеры не хранят в себе информацию, поэтому надо будет подключать внешние volumes в любом случае


- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. <br>
использование Docker контейнеров в этом сценарии будет уместным и удобным


## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```
mikhailrusakovich@Mikhails-MBP data % docker run -it -v $(pwd):/data --name centos -d centos                                 
fee47491bd7376543b6b606cac378aa26015383ae01093a651453d12c540d018
mikhailrusakovich@Mikhails-MBP data % docker exec -it fee47491bd7376543b6b606cac378aa26015383ae01093a651453d12c540d018 /bin/bash
root@fee47491bd73 /]# cd /data/
root@fee47491bd73 data]# ls
myfile.txt
mikhailrusakovich@Mikhails-MBP data % docker run -it -v $(pwd):/data --name debian -d debian                              
074ba40a7532490468964f0e6eace12f22020d42270490cbd83ea9556a1c482b
mikhailrusakovich@Mikhails-MBP data % docker exec -it 074ba40a7532490468964f0e6eace12f22020d42270490cbd83ea9556a1c482b /bin/bash
root@074ba40a7532:/# cd /data
root@074ba40a7532:/data# ls
myfile.txt
root@074ba40a7532:/data# touch newfileindebiancontainer.txt
root@074ba40a7532:/data# ls -al
total 8
drwxr-xr-x 4 root root  128 Nov 11 23:32 .
drwxr-xr-x 1 root root 4096 Nov 11 23:30 ..
rw-r--r-- 1 root root   14 Nov 11 23:16 myfile.txt
rw-r--r-- 1 root root    0 Nov 11 23:32 newfileindebiancontainer.txt
root@074ba40a7532:/data# exit
exit
mikhailrusakovich@Mikhails-MBP data % ls
myfile.txt			newfileindebiancontainer.txt
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

https://hub.docker.com/repository/docker/mikhailrusakovich/ansible

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
