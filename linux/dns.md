Получим DNS сервера котороые отвечают за корневую зону "."
nslookup -type=SOA .

Получим NS записи для ru. зоны. Т.е. список серверов которые отвечают за зону ru.
nslookup -type=NS ru. a.root-servers.net

Теперь спросим у любого из них кто отвечает за зону ru.
nslookup -type=SOA ru. a.dns.ripn.net

Узнаем кто содержит информацию о домене yandex.ru
nslookup -type=NS yandex.ru. a.dns.ripn.net

Узнаем кто овтечает за зону yandex.ru
nslookup -type=SOA yandex.ru ns1.yandex.RU

Узнаем на какой сервер делигирован домен cloud.yandex.ru
nslookup -type=NS cloud.yandex.ru ns1.yandex.RU
