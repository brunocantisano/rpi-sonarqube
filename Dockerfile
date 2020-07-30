FROM paperinik/rpi-java8
MAINTAINER Bruno Cantisano <bruno.cantisano@gmail.com>

LABEL version latest
LABEL description SonarQube Raspberry Pi Container

ENV WRAPPER_VERSION=3.5.43 \
    ANT_VERSION=1.10.8 \
    SONAR_VERSION=7.0 \
    ANT_HOME=/usr/share/ant

RUN apt-get clean \
    && apt-get update \
    && apt-get install -y \
    build-essential \
    wget \
    unzip

RUN cd / \
    && wget --no-check-certificate https://download.tanukisoftware.com/wrapper/${WRAPPER_VERSION}/wrapper_prerelease_${WRAPPER_VERSION}.tar.gz \
    && wget http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && wget --no-check-certificate https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip \
    && tar -xvzf wrapper_prerelease_${WRAPPER_VERSION}.tar.gz \
    && tar -xvzf apache-ant-${ANT_VERSION}-bin.tar.gz \
    && unzip sonarqube-${SONAR_VERSION}.zip \
    && rm -f wrapper_prerelease_${WRAPPER_VERSION}.tar.gz \
    apache-ant-${ANT_VERSION}-bin.tar.gz \
    sonarqube-${SONAR_VERSION}.zip \
    && mv apache-ant-${ANT_VERSION} /usr/share/ant \
    && /wrapper_prerelease_${WRAPPER_VERSION}/build32.sh release

RUN tar -xvzf /wrapper_prerelease_${WRAPPER_VERSION}/dist/wrapper-linux-armhf-32-${WRAPPER_VERSION}.tar.gz

#RUN cp -r /sonarqube-${SONAR_VERSION}/bin/linux-x86-32/ /sonarqube-${SONAR_VERSION}/bin/linux-pi \    
#    && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERSION}/bin/wrapper /sonarqube-${SONAR_VERSION}/bin/linux-pi/wrapper \
#    && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERSION}/lib/libwrapper.so /sonarqube-${SONAR_VERSION}/bin/linux-pi/lib/libwrapper.so \
#    && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERSION}/lib/wrapper.jar /sonarqube-${SONAR_VERSION}/lib/wrapper-${WRAPPER_VERSION}.jar \    
#    && apt-get purge --auto-remove build-essential wget unzip \
#    && rm -rf /wrapper_prerelease_${WRAPPER_VERSION} /wrapper-linux-armhf-32-${WRAPPER_VERION} /usr/share/ant /var/lib/apt/lists/*

#ENV ANT_HOME= 

#WORKDIR /

#COPY files/entrypoint.sh /entrypoint.sh
#RUN chmod 755 /entrypoint.sh

#VOLUME /sonarqube-${SONAR_VERSION}/extensions /sonarqube-${SONAR_VERSION}/logs/

#sonar port
#EXPOSE 9000

#ENTRYPOINT ["/entrypoint.sh"]

#CMD ["app:start"]
