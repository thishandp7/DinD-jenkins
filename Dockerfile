FROM jenkins/jenkins:lts
MAINTAINER Thishan D Pathmanathan <thishandp7@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

USER root

ARG DOCKER_GID=999

RUN groupadd -g ${DOCKER_GID:-999} docker

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    curl \
    python3-dev \
    python3-setuptools \
    gcc make \
    libssl-dev -y && \
    easy_install3 pip


RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce && \
    usermod -a -G docker jenkins && \
    usermod -a -G users jenkins

RUN pip3 install docker-compose==1.17.1

USER jenkins

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
