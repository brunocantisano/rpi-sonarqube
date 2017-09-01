# Sonarqube

![docker_logo](https://raw.githubusercontent.com/brunocantisano/rpi-sonarqube/master/files/docker.png)![docker_sonar_logo](https://raw.githubusercontent.com/brunocantisano/rpi-sonarqube/master/files/logo-sonarqube.png)![docker_paperinik_logo](https://raw.githubusercontent.com/brunocantisano/rpi-sonarqube/master/files/docker_paperinik_120x120.png)

This Docker container implements a Sonarqube Server.

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

* Variable name: `DB_TYPE`
* Default value: MYSQL
* Accepted values: database type. MYSQL, POSTGRES, MSSQL
* Description: database types: mysql, postgres or microsoft sql server
----

* Variable name: `LANGUAGE_VERSION`
* Default value: 1.1
* Description: version of portuguese language plugin.
----


2) If you'd like to run the container, you must download the plugins to a folder and pass the folder path to the container as below:

```bash
docker run -d --name sonarqube \
           -e DB_USER=sonar \
           -e DB_PASS=xaexohquaetiesoo \
           -e DB_NAME=sonar --link postgresql:db \
           -e DB_TYPE=POSTGRES \
           -p 9408:9000 \
           -v /media/usbraid/docker/sonar-scanner/plugins:/sonarqube-5.6.6/extensions/plugins \
           paperinik/rpi-sonarqube:latest

```

# Plugins:
* [GitHub Authentication Plugin](https://docs.sonarqube.org/display/PLUG/GitHub+Authentication+Plugin)
* [Git Plugin](https://docs.sonarqube.org/display/PLUG/Git+Plugin)
* [Sonar Java](https://docs.sonarqube.org/display/PLUG/SonarJava)
* [Sonar C Family for Cpp Plugin](https://www.sonarsource.com/products/codeanalyzers/sonarcfamilyforcpp.html)
* [Sonar Php Plugin](https://www.sonarsource.com/products/codeanalyzers/sonarphp.html)
* [Sonar C Sharp Plugin](https://www.sonarsource.com/products/codeanalyzers/sonarcsharp.html)
* [Sonar Pl Sql Plugin](https://www.sonarsource.com/products/codeanalyzers/sonarplsql.html)
* [Sonar TSql Plugin](https://www.sonarsource.com/products/codeanalyzers/sonartsql.html)
* [Sonar VB6 Plugin](https://www.sonarsource.com/products/codeanalyzers/sonarvb6.html)
* [Sonar VB Net Plugin](https://www.sonarsource.com/products/codeanalyzers/sonarvbnet.html)
* [Sonar Web Plugin](https://www.sonarsource.com/products/codeanalyzers/sonarweb.html)
* [Sonar Xml Plugin](https://www.sonarsource.com/products/codeanalyzers/sonarxml.html)
* [Sonar TS Plugin](https://www.sonarsource.com/products/codeanalyzers/sonarts.html)
* [Sonar CSS Plugin](https://github.com/kalidasya/sonar-css-plugin)
* [Sonar Android Plugin](https://github.com/ofields/sonar-android)
