#!/bin/bash
set -e

trap appStop SIGINT SIGTERM

# Variables
DB_HOST=${DB_HOST:-db}
DB_NAME=${DB_NAME:-sonar}
DB_USER=${DB_USER:-sonar}
DB_PASS=${DB_PASS:-xaexohquaetiesoo}
DB_TYPE=${DB_TYPE:-1}
SONAR_HOST=${SONAR_HOST:-localhost}
SONAR_PORT=${SONAR_PORT:-9000}

# Configure wrapper.conf
sed -i 's/wrapper.java.command=java/wrapper.java.command=\/usr\/lib\/jvm\/jdk-8-oracle-arm32-vfp-hflt\/bin\/java/' /sonarqube-5.6.6/conf/wrapper.conf
sed -i 's|#wrapper.java.additional.6=-server|wrapper.java.additional.6=-server|g' /sonarqube-5.6.6/conf/wrapper.conf

# Configure sonar.properties
sed -i 's|#sonar.jdbc.username=|sonar.jdbc.username='"${DB_USER}"'|g' /sonarqube-5.6.6/conf/sonar.properties
sed -i 's|#sonar.jdbc.password=|sonar.jdbc.password='"${DB_PASS}"'|g' /sonarqube-5.6.6/conf/sonar.properties
sed -i 's|sonar.jdbc.url=jdbc:h2|#sonar.jdbc.url=jdbc:h2|g' /sonarqube-5.6.6/conf/sonar.properties

if [ ${DB_USER} eq 3 ]; then
  # Configure sql server
  sed -i 's|#sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar|sonar.jdbc.url=jdbc:sqlserver://'"${DB_HOST}"';databaseName='"${DB_NAME}"'|g' /sonarqube-5.6.6/conf/sonar.properties
else if [ ${DB_USER} eq 2 ]; then
  # Configure postgres
  sed -i 's|#sonar.jdbc.url=jdbc:postgresql://localhost/sonar|sonar.jdbc.url=jdbc:postgresql://'"${DB_HOST}"'/'"${DB_NAME}"'|g' /sonarqube-5.6.6/conf/sonar.properties
else
  # Configure mysql
  sed -i 's|#sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar|sonar.jdbc.url=jdbc:mysql://'"${DB_HOST}"'/'"${DB_NAME}"'|g' /sonarqube-5.6.6/conf/sonar.properties
fi

# Configure sonar-scanner.properties
sed -i 's|#sonar.host.url=http://localhost:9000|sonar.host.url=http://'"${SONAR_HOST}"':'"${SONAR_PORT}"'|g' /sonar-scanner-3.0.3.778/conf/sonar-scanner.properties
sed -i 's|#sonar|sonar|g' /sonar-scanner-3.0.3.778/conf/sonar-scanner.properties

appStart () {
  echo "Starting sonarqube..."
  set +e
  /sonarqube-5.6.6/bin/linux-pi/sonar.sh start
  tail -f /sonarqube-5.6.6/logs/sonar.log
}

appStop () {
  echo "Stopping sonarqube..."
  /sonarqube-5.6.6/bin/linux-pi/sonar.sh stop
}

appHelp () {
  echo "Available options:"
  echo " app:start          - Starts the sonarqube server (default)"
  echo " app:stop           - Stops the sonarqube server"
  echo " app:help           - Displays the help"
  echo " [command]          - Execute the specified linux command eg. bash."
}

case "$1" in
  app:start)
    appStart
    ;;
  app:stop)
    appStop
    ;;
 app:help)
    appHelp
    ;;
  *)
    if [ -x $1 ]; then
      $1
    else
      prog=$(which $1)
      if [ -n "${prog}" ] ; then
        shift 1
        $prog $@
      else
        appHelp
      fi
    fi
    ;;
esac

exit 0
