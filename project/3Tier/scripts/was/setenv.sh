#!/bin/sh

export JAVA_HOME=/opt/java
export JAVA_JRE=/opt/java
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_JRE/bin

# Tomcat Conf
export JAVA_OPTS=" ${JAVA_OPTS} -server"
export JAVA_OPTS=" ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom"

# Catalina Conf
export CATALINA_OPTS=" ${CATALINA_OPTS} -XX:NewRatio=3"
export CATALINA_OPTS=" ${CATALINA_OPTS} -XX:+DisableExplicitGC"
export CATALINA_OPTS=" ${CATALINA_OPTS} -XX:+HeapDumpOnOutOfMemoryError"
export CATALINA_OPTS=" ${CATALINA_OPTS} -XX:HeapDumpPath=/home/${INSTANCE_OWNER}/was/logs"
export CATALINA_OPTS=" ${CATALINA_OPTS} -verbosegc -XX:+PrintGCDetails"
export CATALINA_OPTS=" ${CATALINA_OPTS} -Xloggc:/home/${INSTANCE_OWNER}/was/logs/gc_`date "+%Y%m%d%H"`.log"