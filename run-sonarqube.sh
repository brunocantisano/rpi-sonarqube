docker run -d --name sonarqube \
           -e DB_USER=sonar \
           -e DB_PASS=xaexohquaetiesoo \
           -e DB_NAME=sonar --link postgresql:db \
           -p 9408:9000 \
           -v /media/usbraid/docker/sonar-scanner/plugins:/sonarqube-5.6.6/extensions/plugins \
           paperinik/rpi-sonarqube:latest
