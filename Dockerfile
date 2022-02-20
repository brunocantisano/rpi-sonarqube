FROM balenalib/raspberry-pi-openjdk:8-stretch

MAINTAINER Bruno Cantisano <bruno.cantisano@gmail.com>

LABEL version latest
LABEL description SonarQube Raspberry Pi Container

ARG SONAR_VERSION 
     
ENV WRAPPER_VERSION=3.5.49 \
    ANT_VERSION=1.10.12 \
    ANT_HOME=/usr/share/ant \
    SONARQUBE_VERSION=${SONAR_VERSION} \
    SONARQUBE_HOME=/sonarqube-${SONAR_VERSION} \
    # Database configuration
    # Defaults to using H2
    # DEPRECATED. Use -v sonar.jdbc.username=... instead
    # Drop these in the next release, also in the run script
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

# Http port
EXPOSE 9000

RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube

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
    && /wrapper_prerelease_${WRAPPER_VERSION}/build32.sh release \
    && tar -xvzf /wrapper_prerelease_${WRAPPER_VERSION}/dist/wrapper-linux-armhf-32-${WRAPPER_VERSION}.tar.gz \
    && cp -r /sonarqube-${SONAR_VERSION}/bin/linux-x86-64/ /sonarqube-${SONAR_VERSION}/bin/linux-pi \
    && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERSION}/bin/wrapper /sonarqube-${SONAR_VERSION}/bin/linux-pi/wrapper \
    && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERSION}/lib/libwrapper.so /sonarqube-${SONAR_VERSION}/bin/linux-pi/lib/libwrapper.so \
    && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERSION}/lib/wrapper.jar /sonarqube-${SONAR_VERSION}/lib/wrapper-${WRAPPER_VERSION}.jar \
    && apt-get purge --auto-remove build-essential wget unzip \
    && rm -rf /wrapper_prerelease_${WRAPPER_VERSION} /wrapper-linux-armhf-32-${WRAPPER_VERION} /usr/share/ant /var/lib/apt/lists/*

ENV ANT_HOME= 

VOLUME $SONARQUBE_HOME/data $SONARQUBE_HOME/extensions $SONARQUBE_HOME/logs/

WORKDIR $SONARQUBE_HOME

COPY files/entrypoint.sh $SONARQUBE_HOME/bin/

USER sonarqube

ENTRYPOINT ["./bin/entrypoint.sh"]
