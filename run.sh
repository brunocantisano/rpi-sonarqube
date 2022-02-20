#!/bin/bash
#
if [ ! "$1" = "" ] | [ ! "$2" = "" ]; then
    echo -e "\ncreating container $1, sonar version: $2 \n\n"
    docker run --rm -u sonarqube -d --name $1 -p 9408:9000 \
               -v ~/projetos/dados/sonar-scanner/plugins:/sonarqube-$2/extensions/plugins \
               paperinik/rpi-sonarqube:latest

else
    echo -e "\nUSAGE: run.sh your-container-name sonar-version \n\n"
fi
