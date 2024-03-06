### Настройка шлюза (iptables)
- Включаем forwarding пакетов: `echo 1 > /proc/sys/net/ipv4/ip_forward`

- Включаем маскарадинг
> iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

- Разрешаем трафик в цепочке FORWARD
> iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT
> iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

- Вариант с SNAT
> iptables -t nat -A POSTROUTING -o enp0s3 -j SNAT --to-source 172.16.16.94
> iptables -t nat -A POSTROUTING -s 192.168.99.0/24 -j SNAT --to-source 172.16.16.94
