# sed

s/что_заменять/на_что_заменять/опции - замена символов, поддерживаются регулярные выражения;

```sh
sed -i 's/my_string/my_new_string/g' my.file
```

- -i - внести изменения в файле. edit files in place
- g - изменить все вхождения

/ - может быть заменен на любой другой разделитель, например - |

sed -i -e "s|name: my-docker|name: my-harbor|" my.file
