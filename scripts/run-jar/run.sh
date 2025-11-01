#!/bin/bash
ACTION=$1
START_WAIT_TIME=2
STOP_WAIT_TIME=1

SHELL_DIR=$(cd `dirname $0`; pwd)
SHELL_HOME=$(dirname ${SHELL_DIR})
echo "SHELL_DIR:"${SHELL_DIR}
echo "SHELL_HOME"${SHELL_HOME}

JAVA_HOME=java
#/home/jdk/jdk-21.0.1+12/bin/java
APP_NAME=hello-springboot-native
APP_VERSION=0.0.1-SNAPSHOT
APP_ENV=test # dev/test/uat/prod
APP_EXE=${APP_NAME}-${APP_VERSION}.jar
APP_HOME=${SHELL_HOME}
APP_PID_FILE=${APP_HOME}/run.pid
APP_LOG_DIR=${APP_HOME}/logs
APP_DUMP_DIR=${APP_LOG_DIR}/dump
JVM_OPTS="-Xms256M -Xmx512M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${APP_DUMP_DIR}"
AGENT_OPTS=""
# AGENT_OPTS="-javaagent:/home/agent/pinpoint-agent-2.5.4/pinpoint-bootstrap.jar -Dpinpoint.applicationName=chengyu-app -Dpinpoint.agentId=chengyu-app-node1 -Dpinpoint.agentName=chengyu-app-node1"
# AGENT_OPTS="-javaagent:/home/agent/skywalking-agent/skywalking-agent.jar=agent.service_name=demo::redis-demo,collector.backend_service=10.10.0.4:11800"

usage() {
  echo "Usage: $0 {start|stop|restart|status}"
  echo "Examples:"
  echo "sh $0 status"
  echo "sh $0 start|stop|restart"
  echo ""
  exit 2
}

start_pre() {
  if [ ! -d "${APP_LOG_DIR}" ];then
    mkdir -p  "${APP_LOG_DIR}"
    echo "logs folder create success"
  else
    echo "logs folder existed"
  fi

  if [ ! -d "${APP_DUMP_DIR}" ];then
      mkdir -p  "${APP_DUMP_DIR}"
      echo "dump folder create success"
    else
      echo "dump folder existed"
  fi
}
start_app() {
  start_pre
  PID=$(ps -ef |grep java|grep ${APP_EXE}|grep -v grep|awk '{print $2}')
  if [ x"${PID}" != x"" ]; then
    echo "App is running..."
    exit 0
  fi
  echo "start app in ${START_WAIT_TIME} seconds..."
  nohup ${JAVA_HOME} ${AGENT_OPTS} ${JVM_OPTS} -DAPP_HOME=${APP_HOME} -jar ${APP_HOME}/lib/${APP_EXE} \
  --spring.config.location=${APP_HOME}/config/application.yml \
  --spring.profiles.active=${APP_ENV} 2>&1 >> ${APP_LOG_DIR}/start.log &
  echo $! > "${APP_PID_FILE}"
  echo "Start ${APP_EXE} success..."
}

stop_app() {
  echo "stop app in ${STOP_WAIT_TIME} seconds..."
  if [ -f "${APP_PID_FILE}" ]; then
    kill -9 `cat ${APP_PID_FILE}`
    rm "${APP_PID_FILE}"
    echo "Stop ${APP_EXE} success..."
  else
    echo "${APP_PID_FILE} not exist, do noting"
  fi
}

start() {
  echo "start app jar"
  start_app
  sleep ${START_WAIT_TIME}
}

stop() {
  echo "Stop app jar"
  stop_app
  sleep ${STOP_WAIT_TIME}
}

restart(){
   echo "Stop app jar"
   stop_app
   sleep ${STOP_WAIT_TIME}

   echo "Restart app jar"
   start_app
   sleep ${START_WAIT_TIME}

}

function status()
{
  PID=$(ps -ef |grep java|grep ${APP_EXE}|grep -v grep|wc -l)
  if [ ${PID} != 0 ];then
    echo "${APP_EXE} is running..."
  else
    echo "${APP_EXE} is not running..."
  fi
}

case "${ACTION}" in
  start)
    start
  ;;
  stop)
    stop
  ;;
  restart)
    restart
  ;;
  status)
    status
  ;;
  *)
    usage
  ;;
esac
