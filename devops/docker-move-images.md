# Копирование images из одного registry в другой

```sh
#!/bin/bash
REGISTRY_ADDRESS=docker.dzanto.ru
REGISTRY_USER=dzanto
REGISTRY_PASSWORD=my_password
REGISTRY_NEW_ADDRESS=new-docker.dzanto.ru

PROJECTS=$(curl -s -X GET -u $REGISTRY_USER:$REGISTRY_PASSWORD https://$REGISTRY_ADDRESS/v2/_catalog | jq -r '.repositories[]')
echo $REPS
for PROJECT in $PROJECTS
    do
        echo $PROJECT
        TAGS=$(curl -s -X GET -u $REGISTRY_USER:$REGISTRY_PASSWORD https://$REGISTRY_ADDRESS/v2/$PROJECT/tags/list | jq -r '.tags[]')
        echo $TAGS
        if [[ $TAGS == *"latest"* ]]; then
            docker pull $REGISTRY_ADDRESS/$PROJECT:latest
            docker tag $REGISTRY_ADDRESS/$PROJECT:latest $REGISTRY_NEW_ADDRESS/$PROJECT:latest
            docker push $REGISTRY_NEW_ADDRESS/$PROJECT:latest
        fi
    done

```
