/var/log/syslog(для deb) или /var/log/messages(для rpm) - глобальный системный журнал

/var/log/auth.log или /var/log/secure - иныормация об авторизации пользователей

/var/log/dmesg - драйвера устройств

### dmesg

dmesg -T - человеческое время

## rsyslog

## logrotate
Можно вручную триггернуть logrotate

## journald

journalctl -- list-boots

journalctl -b <-номер загрузки>