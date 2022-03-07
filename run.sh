#!/bin/bash
#
if [ ! "$1" = "" ] | [ ! "$2" = "" ]; then
    echo -e "\ncreating container $1, sonar version: $2 \n\n"
    docker run -u sonarqube -d --name $1 -p 9408:9000 \
               -v ~/projetos/dados/sonar-scanner/plugins:/sonarqube-$2/extensions/plugins \
               -e SONARQUBE_JDBC_USERNAME="USER" \
               -e SONARQUBE_JDBC_PASSWORD="PASSWORD" \
               -e SONARQUBE_JDBC_URL="jdbc:postgresql://HOST/DATABASE" \
               paperinik/rpi-sonarqube:9.3.0.51899
else
    echo -e "\nUSAGE: run.sh your-container-name sonar-version \n\n"
fi
