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

----

1) If you'd like to run the container:

```bash
docker run --name sonar -it -p 9416:3000 paperinik/rpi-sonarqube
```