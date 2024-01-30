# ACL расширенное упрвление правами

### Просотор прав
getfacl file1

### установить пользователю my_user все права на file1
setfacl -m u:my_user:rvx file1

### установить группе my_group права на чтение file1
setfacl -m g:my_group:r file2

### удалить права 
setfacl -x g:my_group:r file2
---
# umask
дефолтные значения при создании файлов
---
# Capabilites

Установка привиллегий для программ

- CAP_SYS_ADMIN - разрешить диапазон административных операций
- CAP_SYS_BOOT - разрешить вызовы к reboot
- CAP_SYS_CHROOT - разрешить вызовы к chroot

```sh
getcap
setcap
```
---
# Polkit
Установка root привиллегий для различных действий

# PAM
