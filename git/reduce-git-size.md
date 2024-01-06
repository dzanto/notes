---
title: "Уменьшение размера git репозитория"
date: 2023-05-30T15:51:00+03:00
draft: false
tags: [git]
---
Берем за основу документацию GitLab: https://docs.gitlab.com/ee/user/project/repository/reducing_the_repo_size_using_git.html

Перед выполнением работ лучше сделать экспорт проекта. https://docs.gitlab.com/ee/user/project/settings/import_export.html#export-a-project-and-its-data

Клонируем проект с флагом `--bare`
```bash
git clone --bare git@gitlab.my-dev.ru:project.git
```

Запускаем анализ, и смотрим файлы наибольшего размера:
```bash
cd project.git
git filter-repo --analyze
head filter-repo/analysis/*-{all,deleted}-sizes.txt
```

>!!!В итоге файлы в filter-repo/analysis/{path,directories}-deleted-sizes.txt не факт что удалены. Лучше удалять, файлы которые вы точно знаете что нужно удалять.
>
>Сгенерируем файл со списком путей к удаленным файлам(удаленным из существуюих веток, но хранящихся в истории git)
>```bash
>grep -oPh '^(.+\d{4}-\d{2}-\d{2} )\K(.+)' filter-repo/analysis/{path,directories}-deleted-sizes.txt > files-i-dont-want-anymore.txt
>```
>Здесь мы используем grep. -P perl regexp. Опция -o выводит только подходящие под regexp данные, а не всю строку. Ключ \K исключает из regexp стоящее перед ним выражение.
>
>Удаляем файлы из истории git:
>```bash
>git filter-repo --invert-paths --paths-from-file files-i-dont-want-anymore.txt
>```

Для примера: можно удалить один файл, или все файлы больше 10Мб. https://htmlpreview.github.io/?https://github.com/newren/git-filter-repo/blob/docs/html/git-filter-repo.html#EXAMPLES
```bash
git filter-repo --path path/to/file.ext --invert-paths
git filter-repo --strip-blobs-bigger-than 10M
```

Если в репозитории есть protected_tags и protected_branches, снимаем с них protected. Иначе git push выполнится с ошибкой.

Пушим изменения в GitLab
```bash
git push origin --force 'refs/heads/*'
git push origin --force 'refs/tags/*'
git push origin --force 'refs/replace/*'
```

Ждем не менее 30 минут, поскольку процесс очистки хранилища обрабатывает только объекты старше 30 минут.

[Скрипт для автоматизации всех действий](/posts/git/reduce-git-size.py)

Следующий шаг - очистка репозитория:

### Очистка репозитория
https://docs.gitlab.com/ee/user/project/repository/reducing_the_repo_size_using_git.html#repository-cleanup

Settings > Repository

Загружаем сформированный commit-map из каталога filter-repo

Start cleanup.