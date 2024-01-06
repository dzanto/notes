---
title: "awk приёмы работы"
date: 2023-05-31T09:00:00+03:00
draft: false
tags: [bash]
---
Допустим у нас есть текстовый файл example.txt
```
=== Deleted paths by reverse accumulated size ===
Format: unpacked size, packed size, date deleted, path name(s)
      106077     105999 2022-11-24 src/components/organisms/block/assets/MomentaryMain1920.png
       88082      88045 2022-11-24 src/components/organisms/block/assets/MomentaryMain1280.png
       62150      62067 2023-05-02 src/components/pages/details/assets/Background1920.png
```

Вывести 4 столбец, но не выводить первые две строки:
```bash
awk '{if (NR != 1 && NR != 2) print $4}' example.txt
```

NR - это номер строки. $4 - 4 столбец

Тот же результат можно получить использовав substr().
```bash
awk '{if (NR != 1 && NR != 2) print substr($0,36)}' example.txt
```
Здесь $0 - строка, 36 - символ с которого выводится подстрока.
