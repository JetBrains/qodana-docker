ARG RUBY="3.3"
FROM registry.jetbrains.team/p/sa/containers/qodana:ruby-base-$RUBY-latest

ARG TARGETPLATFORM
ARG DEVICEID
ENV DEVICEID=$DEVICEID
COPY $TARGETPLATFORM $QODANA_DIST
RUN chmod +x $QODANA_DIST/bin/*.sh $QODANA_DIST/bin/qodana && \
    update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 0 && \
    update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 0 && \
    update-alternatives --set java $JAVA_HOME/bin/java && \
    update-alternatives --set javac $JAVA_HOME/bin/javac && \
    chmod 777 /etc/passwd && \
    rm -rf /var/cache/apt /var/lib/apt/ /tmp/*

ARG PRIVILEGED="true"
RUN if [ "$PRIVILEGED" = "true" ]; then \
        apt-get update && \
        apt-get install -y sudo && \
        useradd -m -u 1001 -U qodana && \
        passwd -d qodana && \
        echo 'qodana ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
        chmod 777 /etc/passwd && \
        rm -rf /var/cache/apt /var/lib/apt/ /tmp/*; \
    else \
        echo "Skipping privileged commands because PRIVILEGED is not set to true."; \
    fi

LABEL maintainer="qodana-support@jetbrains.com" description="Qodana for Ruby (https://jb.gg/qodana-ruby)"
WORKDIR /data/project
ENTRYPOINT ["/opt/idea/bin/qodana"]
