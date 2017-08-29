# Sonarqube

![docker_logo](https://raw.githubusercontent.com/brunocantisano/rpi-sonarqube/master/files/docker.png)![docker_sonar_logo](https://raw.githubusercontent.com/brunocantisano/rpi-sonarqube/master/files/logo-sonarqube.png)![docker_paperinik_logo](https://raw.githubusercontent.com/brunocantisano/rpi-sonarqube/master/files/docker_paperinik_120x120.png)

This Docker container implements a Sonarqube Server with the Sonar Scanner.

 * Raspbian base image.
 
### Installation from [Docker registry hub](https://registry.hub.docker.com/u/paperinik/rpi-sonarqube/).

You can download the image with the following command:

```bash
docker pull paperinik/rpi-sonarqube
```

# How to use this image

Exposed ports and volumes
----

The image exposes port `9000`. Also, exports two volumes: `/sonarqube-5.6.6/extensions` and `/sonarqube-5.6.6/logs/`, used to store all the plugins and the other is used to store the sonarqube logs.

Use cases

Environment variables
----

1) This image uses environment variables to allow the configuration of some parameteres at run time:

* Variable name: `DB_USER`
* Default value: sonar
* Accepted values: a valid user created in the database.
* Description: database user.
----

* Variable name: `DB_PASS`
* Default value: xaexohquaetiesoo
* Accepted values: a valid password for the user created in the database.
* Description: database password.
----

* Variable name: `DB_NAME`
* Default value: sonar
* Accepted values: database name where the container must connect.
* Description: database name.
----

2) If you'd like to run the container:

```bash
docker run -d --name sonarqube \
           -e DB_USER=sonar \
           -e DB_PASS=xaexohquaetiesoo \
           -e DB_NAME=sonar --link postgresql:db \
           -p 9408:9000 \
           paperinik/rpi-sonarqube:latest
```

3) If you'd like to run the scanner:

```bash
docker run -e SONAR_HOST=192.168.1.30 \
           -e SONAR_PORT=9408 \
           -v /media/usbraid/docker/sonar-scanner/sonarqube-scanner:/var/scanner \
           -it paperinik/rpi-sonarqube sonar-scanner
```

Plugin Links:
https://docs.sonarqube.org/display/PLUG/GitHub+Authentication+Plugin
https://docs.sonarqube.org/display/PLUG/Git+Plugin
https://docs.sonarqube.org/display/PLUG/SonarJava
https://www.sonarsource.com/products/codeanalyzers/sonarcfamilyforcpp.html
https://www.sonarsource.com/products/codeanalyzers/sonarphp.html
https://www.sonarsource.com/products/codeanalyzers/sonarcsharp.html
https://www.sonarsource.com/products/codeanalyzers/sonarplsql.html
https://www.sonarsource.com/products/codeanalyzers/sonartsql.html
https://www.sonarsource.com/products/codeanalyzers/sonarvb6.html
https://www.sonarsource.com/products/codeanalyzers/sonarvbnet.html
https://www.sonarsource.com/products/codeanalyzers/sonarweb.html
https://www.sonarsource.com/products/codeanalyzers/sonarxml.html
https://www.sonarsource.com/products/codeanalyzers/sonarts.html
https://github.com/kalidasya/sonar-css-plugin
https://github.com/ofields/sonar-android