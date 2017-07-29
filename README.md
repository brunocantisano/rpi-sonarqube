# docker rpi-sonarqube, a simple raspberry pi sonarqube container
Runs a small sonarqube server, based on [resin/rpi-raspbian](https://hub.docker.com/r/resin/rpi-raspbian/)
This container was made based on this description [https://gist.github.com/synox/7600843]

### Create an image and a container with Script files
- The script "build.sh" creates a image from Dockerfile with the tag "paperinik/rpi-sonarqube". 
- The script "run.sh" needs one argument, which is a name for the container (e.g. SonarQube). 

### Create the container by hand
Create the container: 
"docker run -d -p 9000:9000 --name SonarQube paperinik/rpi-sonarqube"
