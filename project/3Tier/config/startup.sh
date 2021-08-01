#!/bin/sh

export INSTANCE_OWNER=tomcat
export CATALINA_HOME=/opt/tomcat
export CATALINA_BASE=/home/$INSTANCE_OWNER/was
export CATALINA_PID=/home/$INSTANCE_OWNER/was/run/${INSTANCE_OWNER}.pid

if [ $USER = "root" ]; then
        /bin/su -p -s /bin/sh $INSTANCE_OWNER $CATALINA_HOME/bin/startup.sh
else
        $CATALINA_HOME/bin/startup.sh
fi