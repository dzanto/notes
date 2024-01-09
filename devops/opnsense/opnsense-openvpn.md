# OpenVPN

### Обновление сертификатов

`VPN/OpenVPN/Servers` выбираем сервер

Нам нужно обновить два сертификата в разделе `Cryptographic Settings`:
- `Peer Certificate Authority`
- `Server Certificate`
---
`Peer Certificate Authority` генерируем в `System: Trust: Authorities`

Нажимаем `+`

- Descriptive name - имя
- Method - Create an internal Certificate Authority
- Key length (bits) - 4096
- Digest Algorithm - SHA512
- Заполняем поля в Distinguished name
---
`Server Certificate` генерируем в `System: Trust: Certificates`

Нажимаем `+`

- Method - Create an internal Certificate
- Certificate authority - выбираем `Certificate Authority` созданный на прерыдущем шаге.
- Type - Server Certificate
- Key length (bits) - 4096
- Digest Algorithm - SHA512

### Конфиг для клиентов
`VPN/OpenVPN/Client Export`

Выбираем нужный сервер в `Remote Access Server` и в `Certificate` качаем конфиг и высылаем его клиентам.
