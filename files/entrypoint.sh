#!/bin/bash
set -e

trap appStop SIGINT SIGTERM

# Variables
DB_HOST=${DB_HOST:-db}
DB_NAME=${DB_NAME:-sonar}
DB_USER=${DB_USER:-sonar}
DB_PASS=${DB_PASS:-xaexohquaetiesoo}
DB_TYPE=${DB_TYPE:-MYSQL}
SONAR_HOST=${SONAR_HOST:-localhost}
SONAR_PORT=${SONAR_PORT:-9000}

# Configure wrapper.conf
sed -i 's/wrapper.java.command=java/wrapper.java.command=\/usr\/lib\/jvm\/jdk-8-oracle-arm32-vfp-hflt\/bin\/java/' /sonarqube-7.0/conf/wrapper.conf
sed -i 's|#wrapper.java.additional.6=-server|wrapper.java.additional.6=-server|g' /sonarqube-7.0/conf/wrapper.conf

# Configure sonar.properties
sed -i 's|#sonar.jdbc.username=|sonar.jdbc.username='"${DB_USER}"'|g' /sonarqube-7.0/conf/sonar.properties
sed -i 's|#sonar.jdbc.password=|sonar.jdbc.password='"${DB_PASS}"'|g' /sonarqube-7.0/conf/sonar.properties
sed -i 's|sonar.jdbc.url=jdbc:h2|#sonar.jdbc.url=jdbc:h2|g' /sonarqube-7.0/conf/sonar.properties

appStart () {
  echo "Starting sonarqube..."
  set +e
  if [ "${DB_TYPE}" = "MSSQL" ]; then
    # Configure microsoft sql server
    sed -i 's|#sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar|sonar.jdbc.url=jdbc:sqlserver://'"${DB_HOST}"';databaseName='"${DB_NAME}"'|g' /sonarqube-7.0/conf/sonar.properties
    #echo "mssql"
  elif [ "${DB_TYPE}" = "POSTGRES" ]; then
    # Configure postgres
    sed -i 's|#sonar.jdbc.url=jdbc:postgresql://localhost/sonar|sonar.jdbc.url=jdbc:postgresql://'"${DB_HOST}"'/'"${DB_NAME}"'|g' /sonarqube-7.0/conf/sonar.properties
    #echo "postgres"
  elif [ "${DB_TYPE}" = "MYSQL" ]; then
    # Configure mysql
    sed -i 's|#sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar|sonar.jdbc.url=jdbc:mysql://'"${DB_HOST}"'/'"${DB_NAME}"'|g' /sonarqube-7.0/conf/sonar.properties
    #echo "mysql"
  fi
  /sonarqube-7.0/bin/linux-pi/sonar.sh start
  tail -f /sonarqube-7.0/logs/sonar.log
}

appStop () {
  echo "Stopping sonarqube..."
  /sonarqube-7.0/bin/linux-pi/sonar.sh stop
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
