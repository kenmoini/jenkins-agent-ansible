FROM jenkins/jnlp-slave:alpine as jnlp

FROM node:alpine

WORKDIR /tmp

RUN apk -U add openjdk8-jre wget tar gzip git python ansible && \
    mkdir /.ansible && \
    chmod 777 /.ansible

COPY --from=jnlp /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/slave.jar /usr/share/jenkins/slave.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
