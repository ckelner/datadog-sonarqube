# !/bin/bash

if [ -z $1 ]; then
  echo "No API key passed, exiting"
  exit 1
fi

PWD=$(pwd)
J_OPTS="-Dcom.sun.management.jmxremote= -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.rmi.port=9998 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false"

docker stop sonarqube-sandbox
docker rm sonarqube-sandbox

docker run -d --name sonarqube-sandbox \
  -p 9000:9000 -p 9999:9999 -p 9998:9998 \
  -e SONARQUBE_WEB_JVM_OPTS="${J_OPTS}" \
  -e JAVA_OPTIONS="${J_OPTS}" \
  sonarqube:latest

ADDR=$(docker exec sonarqube-sandbox hostname -i)
sed -i -e "s/localhost/${ADDR}/" ./dd-agent-conf.d/jmx.yaml

docker stop dd-agent-sonar
docker rm dd-agent-sonar

docker run -d --name dd-agent-sonar \
   -v /var/run/docker.sock:/var/run/docker.sock:ro \
   -v /proc/:/host/proc/:ro \
   -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
   -v $PWD/dd-agent-conf.d:/conf.d:ro \
   -e API_KEY=$1 \
   datadog/docker-dd-agent:latest-jmx
