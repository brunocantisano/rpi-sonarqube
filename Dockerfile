FROM paperinik/rpi-java8:latest
MAINTAINER Bruno Cantisano <bruno.cantisano@gmail.com>

LABEL version latest
LABEL description SonarQube Raspberry Pi 2 Container

WORKDIR /

RUN apt-get clean \
    && apt-get update \
    && apt-get install -y \
    build-essential \
    wget \
    unzip \
    && wget https://wrapper.tanukisoftware.com/download/3.5.17/wrapper_prerelease_3.5.17.tar.gz \
    && wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.4-bin.tar.gz \
    && wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-5.6.6.zip \
    && wget https://sonarsource.bintray.com/Distribution/sonar-java-plugin/sonar-java-plugin-4.11.0.10660.jar \
    && wget https://sonarsource.bintray.com/Distribution/sonar-scm-git-plugin/sonar-scm-git-plugin-1.2.jar \
    && wget https://sonarsource.bintray.com/Distribution/sonar-github-plugin/sonar-github-plugin-1.4.1.822.jar \
    && wget https://sonarsource.bintray.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-3.1.1.5128.jar \
    && wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778.zip \
    && tar -xvzf wrapper_prerelease_3.5.17.tar.gz \
    && tar -xvzf apache-ant-1.9.4-bin.tar.gz \
    && unzip sonarqube-5.6.6.zip \
    && unzip sonar-scanner-cli-3.0.3.778.zip \
    && rm -f wrapper_prerelease_3.5.17.tar.gz apache-ant-1.9.4-bin.tar.gz sonarqube-5.6.6.zip sonar-scanner-cli-3.0.3.778.zip \
    && mv sonar-java-plugin-4.11.0.10660.jar sonarqube-5.6.6/extensions/plugins \
    && mv sonar-scm-git-plugin-1.2.jar sonarqube-5.6.6/extensions/plugins \
    && mv sonar-github-plugin-1.4.1.822.jar sonarqube-5.6.6/extensions/plugins \
    && mv sonar-javascript-plugin-3.1.1.5128.jar sonarqube-5.6.6/extensions/plugins \
    && mv apache-ant-1.9.4 /usr/share/ant

ENV ANT_HOME /usr/share/ant
ENV SONAR_SCANNER_OPTS -Xmx512m 
ENV PATH $PATH:/sonar-scanner-3.0.3.778/bin 

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
VOLUME /sonarqube-5.6.6/extensions /sonarqube-5.6.6/logs/ /var/scanner

#sonar port
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["app:start"]
