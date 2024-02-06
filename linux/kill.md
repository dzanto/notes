# kill

kill -l - список сигналов и их номера 
kill -s <signal name> <PID>
kill -<signal name> <PID>
kill -n <signal number> <PID>
kill -<signal number> <PID>

kill <PID> - посылает SIGTERM(15) - мягкое завершение работы

Примеры:
```sh
kill -SIGTERM 8246
kill -s SIGTERM 8246
kill -15 8314
kill -n 15 8314
```

# pkill
Отправить сигнал по имени
pkill -18 <process name>
pkill -18 htop

18 SIGCONT
19 SIGSTOP

# Открыть виртальный терминал

ctrl + alt + f1,f2 - графический
ctrl + alt + f3,f4...f6 - текстовый

# Команды ядру
В случае out of memory нажать:
alt + PrtSc + f - ядро избавится от менее значимых процессов, что бы осовбодить память