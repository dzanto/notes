#!/bin/bash
# /var/lib/pgbackrest/backup.sh

sleeptime=60
maxtries=4

case "$1" in
  full   ) TYPE="$1" ;;
  incr   ) TYPE="$1" ;;
  diff   ) TYPE="$1" ;;
  *      ) echo "incorrect backup type"
           exit 1 ;;
esac

while ! pgbackrest --type="$TYPE" --stanza=main --archive-timeout=600 backup; do
        maxtries=$(( maxtries - 1 ))
        if [ "$maxtries" -eq 0 ]; then
                echo Failed >&2
                exit 1
        fi

        sleep "$sleeptime" || break
done
