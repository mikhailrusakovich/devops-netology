## Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"


### Задача 1

Опишите своими словами основные преимущества применения на практике IaaC паттернов.
Какой из принципов IaaC является основополагающим?
### Задача 2

Чем Ansible выгодно отличается от других систем управление конфигурациями?
Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
### Задача 3

Установить на личный компьютер:

VirtualBox
Vagrant
Ansible
Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.

`mikhailrusakovich@Mikhails-MacBook-Pro ~ % vboxmanage --version`<br>
`6.1.26r145957`<br>

`mikhailrusakovich@Mikhails-MacBook-Pro ~ % vagrant --version` <br>
`Vagrant 2.2.18` <br>

`mikhailrusakovich@Mikhails-MacBook-Pro ~ % ansible --version` <br> 
`ansible [core 2.11.6]` <br>
  `config file = None` <br>
  `configured module search path = ['/Users/mikhailrusakovich/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']`<br> 
  `ansible python module location = /usr/local/Cellar/ansible/4.8.0/libexec/lib/python3.10/site-packages/ansible`<br>
  `ansible collection location = /Users/mikhailrusakovich/.ansible/collections:/usr/share/ansible/collections`<br>
  `executable location = /usr/local/bin/ansible` <br>
  `python version = 3.10.0 (default, Oct 13 2021, 06:45:00) [Clang 13.0.0 (clang-1300.0.29.3)]` <br>
  `jinja version = 3.0.2` <br>
  `libyaml = True`

### Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Создать виртуальную машину.
Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
docker ps

