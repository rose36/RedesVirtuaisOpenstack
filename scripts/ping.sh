#!/bin/bash
#Autora: Roseli da Rocha Barbosa

SECONDS=0
i=0

while [ $SECONDS -le $1 ]
do
        if [ $i -eq 0 ]
        then
                ping $2 &
                i=1
        elif [ $SECONDS -ge $1 ]
        then
                #exit 0
                break
        fi
done
killall -s SIGINT ping

