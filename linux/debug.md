- uptime
- dmesg | tail
- vmstat 1
- mpstat -P ALL 1
- pidstat 1
- Observability base
- iostat -xz 1
- free m
- sar -n DEV 1
- sar -n TCP,ETCP 1
- top

# Число процессов, стоящих в очереди на исполнение
```sh
cat /proc/loadavg

# 0.84 0.66 0.37 1/1493 10174
```

```sh
uptime

# 12:16:11 up  2:27,  2 users,  load average: 0.54, 0.60, 0.37
```

Просмотр загрузки процессора
```sh
mpstat -P ALL # нагрузка по каждому ядру/потоку
mpstat -P ALL 1 # нагрузка по каждому ядру/потоку, вывод каждую секунду
mpstat # общая нагрузка

# Linux 6.6.11-200.fc39.x86_64 (fedora) 	20/01/24 	_x86_64_	(16 CPU)

# 12:34:01     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
# 12:34:01     all    0.72    0.00    0.64    0.05    0.12    0.04    0.00    0.00    0.00   98.43
```

```sh
free -m
#                total        used        free      shared  buff/cache   available
# Mem:           27742        4150       19078         194        5141       23591
# Swap:           8191           0        8191
```

```sh
iostat
# Linux 6.6.11-200.fc39.x86_64 (fedora) 	20/01/24 	_x86_64_	(16 CPU)

# avg-cpu:  %user   %nice %system %iowait  %steal   %idle
#            0.93    0.00    0.80    0.05    0.00   98.22

# Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
# nvme0n1          22.14       227.05       279.68       388.09    3015632    3714657    5154428
# zram0             0.00         0.09         0.00         0.00       1176          4          0
```

#### sar - универсальная утилита для просмотра ресурсов
Ключи
- -r Memory utilization statistics
- -S Swap space utilization statistics
- -u CPU utilization statistics

- первое число - интервал вывода данных
- второе число - сколько раз выводить данные
```sh
sar -rh 1 2
# Linux 6.6.11-200.fc39.x86_64 (fedora) 	20/01/24 	_x86_64_	(16 CPU)

# 13:35:19    kbmemfree   kbavail kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty
# 13:35:20        18.2G     22.8G      3.5G     12.9%      4.4M      4.9G     11.3G     32.2%      5.2G      2.6G    548.0k
# 13:35:21        18.2G     22.8G      3.5G     12.9%      4.4M      4.9G     11.3G     32.2%      5.2G      2.6G    548.0k
# Average:        18.2G     22.8G      3.5G     12.9%      4.4M      4.9G     11.3G     32.2%      5.2G      2.6G    548.0k

sar -u 1 2
# Linux 6.6.11-200.fc39.x86_64 (fedora) 	20/01/24 	_x86_64_	(16 CPU)

# 13:37:49        CPU     %user     %nice   %system   %iowait    %steal     %idle
# 13:37:50        all      0.87      0.00      0.56      0.00      0.00     98.57
# 13:37:51        all      0.57      0.00      0.38      0.00      0.00     99.06
# Average:        all      0.72      0.00      0.47      0.00      0.00     98.81
```

sar сохраняет статистику в лог файлах /var/log/sa/sa*

```sh
sar -q -f /var/log/sa/sa15 -s 10:00:00
# -q - просмотр load-average
# -f читать данные из файла
# -s время с которого показывать данные, работает только с опцией -f
```

### top
- us(usr) - user space
- sy(sys) - kernel space
- ni(nice) - процессорное время для процессов с измененным приоритетом
- id(idle) - простой, бездействие
- wa(iowait) - ожидание ввода/вывода с диска, сети 
- hi(irq) - hardware interrupt(interrupt request) запросы прерывания от hardware устройств
- si(soft) - програмные прерывания
- st(steal) - искусственные ограничения использования ЦПУ в ВМ.

Нажать 1 - покажет загрузку по каждому процессу

Инструменты
- strace
- tcpdump
- netstat/ss
- nicstat
- pidstat
- swapon
- lsof
- sar -n DEV 1
- sar -n TCP,ETCP 1


### ethtool - работа с сетевыми картами
```sh
ethtool --show-permaddr enp2s0
# Permanent address: 84:s7:16:a3:a1:g8

ethtool --show-features enp2s0
# Features for enp2s0:
# rx-checksumming: on
# tx-checksumming: on
# 	tx-checksum-ipv4: on
# 	tx-checksum-ip-generic: off [fixed]
# 	tx-checksum-ipv6: on
# 	tx-checksum-fcoe-crc: off [fixed]
# 	tx-checksum-sctp: off [fixed]
# scatter-gather: off
# 	tx-scatter-gather: off
# 	tx-scatter-gather-fraglist: off [fixed]
# tcp-segmentation-offload: off
# 	tx-tcp-segmentation: off
# 	tx-tcp-ecn-segmentation: off [fixed]
# 	tx-tcp-mangleid-segmentation: off
# 	tx-tcp6-segmentation: off
# generic-segmentation-offload: off [requested on]
# generic-receive-offload: on
# large-receive-offload: off [fixed]
# rx-vlan-offload: on

sudo ethtool --identify enp2s0
# помигать индикатором порта на сетевой карте
```

### iperf - тестирование скорости сети

На сервере
```sh
iperf3 -s
# -s - слушать порт 5201
```

На клиенте
```sh
iperf3 -c <ip сервера> -t 40 -i 5
# подключиться к серверу
```

cat /proc/meminfo

#### проверить скорость записи диска
dd if=/dev/zer of=file bs=512 count=1000 oflag=dsync

# Observability advanced

ltrace
● ethtool
● iotop
● blktrace
● slabtop
● /proc
● pcstat
Observability advanced
● Метрики CPU:
○ perf_events, tiptop, rdmsr
● Продвинутый трейсинг:
○ perf_events, ftrace, eBPF,
dtrace, etc…

# Benchmark
● Multitools:
○ unixbench/sysbench/perf bench
● FS/disk:
○ dd/hdparm
● App/lib:
○ ab/wrk/jmeter/openssl/yandextank
● Network:
○ ping/hping3/iperf/ttcp/pchar

# Tuning

● sysctl или /sys
● Application config
● CPU/scheduler:nice/renice/taskset/ulimit/chcpu
● Storage I/O: tune2fs/ionice/hdparm/blockdev
● Network: ethtool/tc/ip/route
● Dynamic patching: stap/kpatch
