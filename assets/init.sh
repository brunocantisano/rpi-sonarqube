#!/bin/bash
set -e

trap appStop SIGINT SIGTERM

# Variables
DB_HOST=${DB_HOST:-db}
DB_NAME=${DB_NAME:-sonar}
DB_USER=${DB_USER:-sonar}
DB_PASS=${DB_PASS:-xaexohquaetiesoo}

# Configure wrapper.conf
sed -i 's/wrapper.java.command=java/wrapper.java.command=\/usr\/lib\/jvm\/jdk-8-oracle-arm32-vfp-hflt\/bin\/java/' /sonarqube-5.6.6/conf/wrapper.conf 
sed -i 's|#wrapper.java.additional.6=-server|wrapper.java.additional.6=-server|g' /sonarqube-5.6.6/conf/wrapper.conf 

# Configure sonar.properties
sed -i 's|#sonar.jdbc.username=|sonar.jdbc.username='"${DB_USER}"'|g' /sonarqube-5.6.6/conf/sonar.properties 
sed -i 's|#sonar.jdbc.password=|sonar.jdbc.password='"${DB_PASS}"'|g' /sonarqube-5.6.6/conf/sonar.properties 
sed -i 's|sonar.jdbc.url=jdbc:h2|#sonar.jdbc.url=jdbc:h2|g' /sonarqube-5.6.6/conf/sonar.properties 
sed -i 's|#sonar.jdbc.url=jdbc:postgresql://localhost/sonar|sonar.jdbc.url=jdbc:postgresql://'"${DB_HOST}"'/'"${DB_NAME}"'|g' /sonarqube-5.6.6/conf/sonar.properties 

appStart () {
  echo "Starting sonarqube..."
  set +e
  /sonarqube-5.6.6/bin/linux-pi/sonar.sh start
  tail -f /sonarqube-5.6.6/logs/sonar.log
}

appHelp () {
  echo "Available options:"
  echo " app:start          - Starts the sonarqube server (default)"
  echo " app:help           - Displays the help"
  echo " [command]          - Execute the specified linux command eg. bash."
}

case "$1" in
  app:start)
    appStart
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
