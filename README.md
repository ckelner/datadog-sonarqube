# Sonarqube

This is a quick POC - use with caution.

## Prerequisites

- Install docker

## Run

- `bash run.sh <your-datadog-api-key>`
  - This will run two docker containers, one w/ sonarqube and one with the docker-dd-agent
- Connect to localhost:9000
- Download the CLI scanner at https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner
  - Update sonar-scanner.properties to point to `localhost:9000`
- Choose a project to scan or download the examples at https://github.com/SonarSource/sonar-examples/zipball/master
  - I suggest the [projects/languages/generic-coverage/sonar-runner](https://github.com/SonarSource/sonar-examples/tree/master/projects/languages/generic-coverage/sonar-runner) project
- Change into the directory where the code and configuration is
- Run `<path-to-executable>/sonar-scanner`
- You can find JMX metrics under the `jmx.sonarqube.x` namespace and JVM under the `jvm.x` namespace!
