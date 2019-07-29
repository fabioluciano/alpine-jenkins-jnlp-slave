ARG OPENJDK_VERSION='12'

FROM openjdk:${OPENJDK_VERSION}-jdk-alpine
LABEL maintainer="Integr8"

# Jenkins Variables
ARG JENKINS_AGENT_VERSION='3.33'
ARG JENKINS_USERNAME=jenkins
ARG JENKINS_UID=1000
ARG JENKINS_GID=1000
ARG JENKINS_GROUP=jenkins

ENV HOME /home/${JENKINS_USERNAME}
ENV AGENT_WORKDIR ${HOME}/agent

COPY jenkins-slave /usr/local/bin/jenkins-slave

RUN apk add --update --no-cache curl bash git git-lfs openssh-client openssl procps \
    && addgroup -g ${JENKINS_GID} ${JENKINS_GROUP} \
    && adduser -h /home/${JENKINS_USERNAME} -u ${JENKINS_UID} -G ${JENKINS_GROUP} -D ${JENKINS_USERNAME} \
    && curl --create-dirs -fsSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JENKINS_AGENT_VERSION}/remoting-${JENKINS_AGENT_VERSION}.jar \
    && chmod 755 /usr/share/jenkins && chmod 644 /usr/share/jenkins/slave.jar \
    && mkdir ${HOME}/{.jenkins,agent}

USER ${JENKINS_USERNAME}

VOLUME ${HOME}/.jenkins
VOLUME ${AGENT_WORKDIR}

WORKDIR ${HOME}

ENTRYPOINT ["jenkins-slave"]