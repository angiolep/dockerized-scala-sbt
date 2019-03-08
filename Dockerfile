FROM alpine:3.8

LABEL descrption="This image provides a minimal Linux setup to perform Scala SBT-based builds of applications for the JVM - Java Virtual Machine"
LABEL maintainer="pangiole@tibco.com"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
 && chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION 8u191
ENV JAVA_ALPINE_VERSION 8.191.12-r0

RUN set -x \
 && apk add --no-cache \
    git \
    openjdk8="$JAVA_ALPINE_VERSION" \
 && [ "$JAVA_HOME" = "$(docker-java-home)" ]


ENV SBT_VERSION="1.2.3" \
    SBT_HOME="/opt/sbt" \
    SBT_CACHE="/cache" \
    PATH="/opt/sbt/bin:$PATH"

WORKDIR /project

ADD sbtopts /etc/sbt/sbtopts

# Install SBT - the interactive build tool
RUN set -ex && \
    apk -U upgrade && \
    apk --no-cache add vim bash curl gzip tar && \
    curl -OL https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz && \
    mkdir -p /opt && \
    tar xvfz sbt-${SBT_VERSION}.tgz -C /opt && \
    rm -f sbt-${SBT_VERSION}.tgz && \
    mv /opt/sbt/ /opt/sbt-${SBT_VERSION} && \
    ln -s sbt-${SBT_VERSION} /opt/sbt && \
    mkdir -p /etc/sbt ${SBT_CACHE} && \
    \
    # Clean-up
    rm -rf /var/cache/apk/*

# Install Microsoft TFF - True Fonts Face
RUN apk --no-cache add msttcorefonts-installer fontconfig && \
    update-ms-fonts && \
    fc-cache -f

ENTRYPOINT ["/opt/sbt/bin/sbt", "-v"]
