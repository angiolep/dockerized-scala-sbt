FROM alpine:3.9.2

LABEL descrption="This image provides a minimal Linux setup to perform Scala SBT-based builds of applications for the JVM - Java Virtual Machine"
LABEL maintainer="pangiole@tibco.com"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
 && chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION 8u201
ENV JAVA_ALPINE_VERSION 8.201.08-r0

RUN set -x \
 && apk add --no-cache \
    git \
    openjdk8="$JAVA_ALPINE_VERSION" \
 && [ "$JAVA_HOME" = "$(docker-java-home)" ]

# TODO ENV version
ARG version="1.2.8"
ENV SBT_VERSION=$version \
    SBT_HOME="/opt/sbt" \
    PATH="/opt/sbt/bin:$PATH"

ADD sbtopts /etc/sbt/sbtopts

RUN major=$(echo "$version" | cut -d '.' -f 1) && \
    minor=$(echo "$version" | cut -d '.' -f 2) && \
    echo "-J-Dsbt.dependency.base=/cache/.sbt/${major}.${minor}/dependency" >> /etc/sbt/sbtopts

# Install SBT - the interactive build tool
RUN set -ex && \
    apk -U upgrade && \
    apk --no-cache add bash curl gzip nss tar vim zip && \
    curl -OL https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz && \
    mkdir -p /opt && \
    tar xvfz sbt-${version}.tgz -C /opt && \
    rm -f sbt-${version}.tgz && \
    mv /opt/sbt/ /opt/sbt-${version} && \
    ln -s sbt-${version} /opt/sbt && \
    \
    # Clean-up
    rm -rf /var/cache/apk/*

# Install Microsoft TFF - True Fonts Face
RUN apk --no-cache add msttcorefonts-installer fontconfig && \
    update-ms-fonts && \
    fc-cache -f

# Create a few users
RUN addgroup  -S hadoop && \
    adduser -S alice -G hadoop

# TODO build Hadoop native libraries for this Linux Alpine

ENTRYPOINT ["/opt/sbt/bin/sbt", "-v"]
