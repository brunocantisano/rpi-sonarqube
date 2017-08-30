FROM paperinik/rpi-java8:latest
MAINTAINER Bruno Cantisano <bruno.cantisano@gmail.com>

LABEL version latest
LABEL description SonarQube Raspberry Pi 2 Container

WORKDIR / \

ENV LANGUAGE_VERSION 1.1

RUN apt-get clean \
    && apt-get update \
    && apt-get install -y \
    build-essential \
    wget \
    unzip \
    && wget https://wrapper.tanukisoftware.com/download/3.5.17/wrapper_prerelease_3.5.17.tar.gz && tar -xvzf wrapper_prerelease_3.5.17.tar.gz && rm -f wrapper_prerelease_3.5.17.tar.gz \
    && wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.4-bin.tar.gz && tar -xvzf apache-ant-1.9.4-bin.tar.gz && rm -f apache-ant-1.9.4-bin.tar.gz && mv apache-ant-1.9.4 /usr/share/ant \
    && wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-5.6.6.zip && unzip sonarqube-5.6.6.zip && rm -f sonarqube-5.6.6.zip \
    && wget http://www.java2s.com/Code/JarDownload/sonar-l10n/sonar-l10n-pt-plugin-$LANGUAGE_VERSION.jar.zip && unzip /sonar-l10n-pt-plugin-$LANGUAGE_VERSION.jar.zip && rm -f sonar-l10n-pt-plugin-$LANGUAGE_VERSION.jar.zip \
    && mv sonar-l10n-pt-plugin-$LANGUAGE_VERSION.jar /sonarqube-5.6.6/extensions/plugins 

ENV ANT_HOME /usr/share/ant

RUN /wrapper_prerelease_3.5.17/build32.sh release \
    && tar -xvzf /wrapper_prerelease_3.5.17/dist/wrapper-linux-armhf-32-3.5.17.tar.gz \    
    && cp -r /sonarqube-5.6.6/bin/linux-x86-32/ /sonarqube-5.6.6/bin/linux-pi \    
    && cp -f /wrapper-linux-armhf-32-3.5.17/bin/wrapper /sonarqube-5.6.6/bin/linux-pi/wrapper \
    && cp -f /wrapper-linux-armhf-32-3.5.17/lib/libwrapper.so /sonarqube-5.6.6/bin/linux-pi/lib/libwrapper.so \
    && cp -f /wrapper-linux-armhf-32-3.5.17/lib/wrapper.jar /sonarqube-5.6.6/lib/wrapper-3.5.17.jar \    
    && apt-get purge --auto-remove build-essential wget unzip \
    && rm -rf /wrapper_prerelease_3.5.17 /wrapper-linux-armhf-32-3.5.17 /usr/share/ant /var/lib/apt/lists/*

ENV ANT_HOME= 

COPY files/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

WORKDIR /var/scanner
VOLUME /sonarqube-5.6.6/extensions /sonarqube-5.6.6/logs

#sonar port
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["app:start"]
