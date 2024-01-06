# Как получить список GitLab репозиториев с размерами

```bash
GITLAB_HTTP_HOST="gitlab.my-dev.ru"
GITLAB_PRIVATE_TOKEN="glpat-xxx"

rm -f projects.json

for page in 1 2
    do
        curl --request GET --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://$GITLAB_HTTP_HOST/api/v4/projects/?statistics=true&page=${page}&per_page=100&order_by=name&sort=asc" | jq '.[]' >> projects.json
    done

cat projects.json | jq -cr '[ .statistics.repository_size, .name ] | join(" ")' | while read line;
    do
        echo $line;
    done | sort -rn
```

- Список проектов выдается постранично, не более 100 проектов на страницу, по этому делаем цикл для двух страниц.
- projects.json - промежуточный файл для хранения списка проектов