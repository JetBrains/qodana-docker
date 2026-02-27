FROM registry.jetbrains.team/p/sa/containers/qodana:go-base-latest

ARG TARGETPLATFORM
ARG DEVICEID
ENV DEVICEID=$DEVICEID
COPY $TARGETPLATFORM $QODANA_DIST
RUN chmod +x $QODANA_DIST/bin/*.sh $QODANA_DIST/bin/qodana && \
    update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 0 && \
    update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 0 && \
    update-alternatives --set java $JAVA_HOME/bin/java && \
    update-alternatives --set javac $JAVA_HOME/bin/javac && \
    rm -rf /var/cache/apt /var/lib/apt/ /tmp/*

RUN curl -fsSL "https://go.dev/dl/go1.26.0.linux-$(dpkg --print-architecture).tar.gz" -o /tmp/go1.26.0.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf /tmp/go1.26.0.tar.gz && \
    rm /tmp/go1.26.0.tar.gz

ENV GOROOT="/usr/local/go"

LABEL maintainer="qodana-support@jetbrains.com" description="Qodana for Go (https://jb.gg/qodana-go)"
WORKDIR /data/project
ENTRYPOINT ["/opt/idea/bin/qodana"]
