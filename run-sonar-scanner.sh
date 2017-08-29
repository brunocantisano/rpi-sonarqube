#!/bin/bash

if [ ! "$1" = "" ] && [ ! "$2" = "" ] && [ ! "$3" = "" ]; then
    echo -e "\ncreating container rpi-sonar-scanner\n\n"
    docker run -e SONAR_HOST=$1 -e SONAR_PORT=$2 -v $3:/var/scanner -it paperinik/rpi-sonarqube sonar-scanner
else
    echo -e "\nUSAGE: run.sh sonar_hostname sonar_port path_to_analize\n\n"
fi
