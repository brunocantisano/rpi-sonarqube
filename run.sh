#!/bin/bash
#
if [ ! "$1" = "" ]; then
    echo -e "\ncreating container $1\n\n"
    docker run -d -p 9408:9000 \
               --env DB_USER=sonar \
               --env DB_PASS=xaexohquaetiesoo \
               --env DB_NAME=sonar \
               --env DB_TYPE=POSTGRES \
               --name $1 paperinik/rpi-sonarqube
else
    echo -e "\nUSAGE: run.sh your-container-name \n\n"
fi
