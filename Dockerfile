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
    && wget https://wrapper.tanukisoftware.com/download/3.5.17/wrapper_prerelease_3.5.17.tar.gz && tar -xvzf wrapper_prerelease_3.5.17.tar.gz && rm -f wrapper_prerelease_3.5.17.tar.gz \
    && wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.4-bin.tar.gz && tar -xvzf apache-ant-1.9.4-bin.tar.gz && rm -f apache-ant-1.9.4-bin.tar.gz && mv apache-ant-1.9.4 /usr/share/ant \
    && wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-5.6.6.zip && unzip sonarqube-5.6.6.zip && rm -f sonarqube-5.6.6.zip \
    && wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778.zip && unzip sonar-scanner-cli-3.0.3.778.zip && rm -f sonar-scanner-cli-3.0.3.778.zip \
    && wget https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/3.0.2.656/sonar-scanner-msbuild-3.0.2.656.zip && unzip sonar-scanner-msbuild-3.0.2.656.zip && rm -f sonar-scanner-msbuild-3.0.2.656.zip \
    && wget https://sonarsource.bintray.com/Distribution/sonar-java-plugin/sonar-java-plugin-4.11.0.10660.jar -P sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/Distribution/sonar-scm-git-plugin/sonar-scm-git-plugin-1.2.jar -P sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/Distribution/sonar-github-plugin/sonar-github-plugin-1.4.1.822.jar -P sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-3.1.1.5128.jar -P sonarqube-5.6.6/extensions/plugins \
    && wget http://www.java2s.com/Code/JarDownload/sonar-l10n/sonar-l10n-pt-plugin-1.1.jar.zip && unzip /sonar-l10n-pt-plugin-1.1.jar.zip && rm -f sonar-l10n-pt-plugin-1.1.jar.zip && mv sonar-l10n-pt-plugin-1.1.jar /sonarqube-5.6.6/extensions/plugins \ 
    && wget http://www.java2s.com/Code/JarDownload/sonar-android/sonar-android-plugin-0.1.jar.zip && unzip sonar-android-plugin-0.1.jar.zip && rm -f sonar-android-plugin-0.1.jar.zip && mv sonar-android-plugin-0.1.jar /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/CommercialDistribution/sonar-cfamily-plugin/sonar-cfamily-plugin-4.11.0.8443.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/Distribution/sonar-php-plugin/sonar-php-plugin-2.10.0.2087.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/Distribution/sonar-csharp-plugin/sonar-csharp-plugin-6.3.0.2862.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/CommercialDistribution/sonar-plsql-plugin/sonar-plsql-plugin-2.9.1.1051.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/Distribution/sonar-python-plugin/sonar-python-plugin-1.8.0.1496.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/CommercialDistribution/sonar-tsql-plugin/sonar-tsql-plugin-1.0.1.2094.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/CommercialDistribution/sonar-vb-plugin/sonar-vb-plugin-2.2.1.886.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/CommercialDistribution/sonar-vbnet-plugin/sonar-vbnet-plugin-3.0.3.346.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/Distribution/sonar-web-plugin/sonar-web-plugin-2.5.0.476.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/Distribution/sonar-xml-plugin/sonar-xml-plugin-1.4.3.1027.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://github.com/racodond/sonar-css-plugin/releases/download/4.9/sonar-css-plugin-4.9.jar -P /sonarqube-5.6.6/extensions/plugins \
    && wget https://sonarsource.bintray.com/Distribution/sonar-typescript-plugin/sonar-typescript-plugin-1.0.0.340.jar -P /sonarqube-5.6.6/extensions/plugins 

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
