FROM paperinik/rpi-java8
MAINTAINER Bruno Cantisano <bruno.cantisano@gmail.com>

LABEL version latest
LABEL description SonarQube Raspberry Pi Container

ENV WRAPPER_VERION=3.5.17 \
    ANT_VERSION=1.9.4 \
    SONAR_VERSION=5.6.6 \
    LANGUAGE_VERSION=1.1 \
    ANT_HOME=/usr/share/ant

RUN apt-get clean \
    && apt-get update \
    && apt-get install -y \
    build-essential \
    wget \
    unzip \
    && cd / \
    && wget https://wrapper.tanukisoftware.com/download/${WRAPPER_VERION}/wrapper_prerelease_${WRAPPER_VERION}.tar.gz \
    && wget http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip \        
    && wget http://www.java2s.com/Code/JarDownload/sonar-l10n/sonar-l10n-pt-plugin-$LANGUAGE_VERSION.jar.zip \
    && tar -xvzf wrapper_prerelease_${WRAPPER_VERION}.tar.gz \
    && tar -xvzf apache-ant-${ANT_VERSION}-bin.tar.gz \
    && unzip sonarqube-${SONAR_VERSION}.zip \
    && unzip sonar-l10n-pt-plugin-$LANGUAGE_VERSION.jar.zip \
    && rm -f wrapper_prerelease_${WRAPPER_VERION}.tar.gz \
    apache-ant-${ANT_VERSION}-bin.tar.gz \
    sonarqube-${SONAR_VERSION}.zip \
    sonar-l10n-pt-plugin-$LANGUAGE_VERSION.jar.zip \
    && mv sonar-l10n-pt-plugin-$LANGUAGE_VERSION.jar sonarqube-${SONAR_VERSION}/extensions/plugins \    
    && mv apache-ant-${ANT_VERSION} /usr/share/ant \
    && /wrapper_prerelease_${WRAPPER_VERION}/build32.sh release \
    && tar -xvzf /wrapper_prerelease_${WRAPPER_VERION}/dist/wrapper-linux-armhf-32-${WRAPPER_VERION}.tar.gz \    
    && cp -r /sonarqube-${SONAR_VERSION}/bin/linux-x86-32/ /sonarqube-${SONAR_VERSION}/bin/linux-pi \    
    && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERION}/bin/wrapper /sonarqube-${SONAR_VERSION}/bin/linux-pi/wrapper \
    && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERION}/lib/libwrapper.so /sonarqube-${SONAR_VERSION}/bin/linux-pi/lib/libwrapper.so \
    && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERION}/lib/wrapper.jar /sonarqube-${SONAR_VERSION}/lib/wrapper-${WRAPPER_VERION}.jar \    
    && apt-get purge --auto-remove build-essential wget unzip \
    && rm -rf /wrapper_prerelease_${WRAPPER_VERION} /wrapper-linux-armhf-32-${WRAPPER_VERION} /usr/share/ant /var/lib/apt/lists/*

ENV ANT_HOME= 

WORKDIR /

COPY files/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

VOLUME /sonarqube-${SONAR_VERSION}/extensions /sonarqube-${SONAR_VERSION}/logs/

#sonar port
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["app:start"]