#!/bin/bash
#
if [ ! "$1" = "" ]; then
    echo -e "\ncreating container $1\n\n"
    docker run -u 0 -d -p 9408:9000 \
               -v `pwd`/sonar-scanner/plugins:/sonarqube-$(DOCKER_IMAGE_VERSION)/extensions/plugins \
               --name $1 paperinik/rpi-sonarqube:latest
else
    echo -e "\nUSAGE: run.sh your-container-name \n\n"
fi
