ARG BASE_TAG="bullseye-slim"
FROM debian:$BASE_TAG

ARG TARGETPLATFORM

ENV HOME="/root" LC_ALL="en_US.UTF-8" QODANA_DIST="/opt/idea" QODANA_DATA="/data"
ENV JAVA_HOME="$QODANA_DIST/jbr" QODANA_DOCKER="true" QODANA_CONF="$HOME/.config/idea"

ENV PATH="$QODANA_DIST/bin:$PATH"

RUN mkdir -m 777 -p /opt $QODANA_DATA $QODANA_CONF && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      fontconfig \
      git \
      gnupg2 \
      locales \
      procps && \
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen && \
    apt-get autoremove -y && apt-get clean && \
    chmod 777 -R $HOME && \
    echo 'root:x:0:0:root:/root:/bin/bash' > /etc/passwd && chmod 666 /etc/passwd && \
    git config --global --add safe.directory '*' && \
    rm -rf /var/cache/apt /var/lib/apt/ /tmp/*

ENV CONDA_DIR="/opt/miniconda3" CONDA_ENVS_PATH="$QODANA_DATA/cache/conda/envs" CONDA_PKGS_DIRS="$QODANA_DATA/cache/conda/pkgs" PIP_CACHE_DIR="$QODANA_DATA/cache/.pip/" FLIT_ROOT_INSTALL=1
ENV PATH="$CONDA_DIR/bin:$HOME/.local/bin:$PATH"
ARG CONDA_VERSION="py310_22.11.1-1"

RUN apt-get update &&  \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      bzip2 \
      libglib2.0-0 \
      libsm6 \
      libxext6 \
      libxrender1 \
      procps && \
    mkdir -m 777 -p $QODANA_DATA/cache && \
    case $TARGETPLATFORM in \
      linux/amd64)  \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh" \
        SHA256SUM="00938c3534750a0e4069499baf8f4e6dc1c2e471c86a59caa0dd03f4a9269db6";; \
      linux/arm64)  \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-aarch64.sh"  \
        SHA256SUM="48a96df9ff56f7421b6dd7f9f71d548023847ba918c3826059918c08326c2017";; \
      *) echo "Unsupported architecture $TARGETPLATFORM or you forgot to enable Docker BuildKit" >&2; exit 1;; \
    esac && \
    curl -fsSL -o /tmp/miniconda.sh "${MINICONDA_URL}" && \
    echo "${SHA256SUM} /tmp/miniconda.sh" > /tmp/shasum && \
    if [ "${CONDA_VERSION}" != "latest" ]; then sha256sum --check --status /tmp/shasum; fi && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    ln -s ${CONDA_DIR}/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && ln -s ${CONDA_DIR}/bin/python3 /usr/bin/python3 && \
    find ${CONDA_DIR}/ -follow -type f -name '*.a' -delete && find ${CONDA_DIR}/ -follow -type f -name '*.js.map' -delete && \
    ${CONDA_DIR}/bin/conda install -c conda-forge poetry pipenv && ${CONDA_DIR}/bin/conda clean -afy && \
    rm -rf /var/cache/apt /var/lib/apt/ /tmp/*

ARG QD_BUILD="QDPYC-2023.2"
ARG QD_RELEASE="2023.2"
RUN set -ex && \
    dpkgArch="$(dpkg --print-architecture)" && \
    case "$dpkgArch" in \
        'amd64') \
            OS_ARCH_SUFFIX=''; \
            ;; \
        'arm64') \
            OS_ARCH_SUFFIX='-aarch64'; \
            ;; \
        *) echo "Unsupported architecture $dpkgArch" >&2; exit 1 ;; \
    esac && \
    QD_NAME="qodana-$QD_BUILD$OS_ARCH_SUFFIX" \
    QD_URL="https://download.jetbrains.com/qodana/$QD_RELEASE/$QD_NAME.tar.gz" && \
    curl -fsSL "$QD_URL" -o /tmp/$QD_NAME.tar.gz \
        "$QD_URL.sha256" -o /tmp/$QD_NAME.tar.gz.sha256 \
        "$QD_URL.sha256.asc" -o /tmp/$QD_NAME.tar.gz.sha256.asc && \
    export GNUPGHOME="$(mktemp -d)" && \
    for key in \
        "B46DC71E03FEEB7F89D1F2491F7A8F87B9D8F501" \
      ; do \
        gpg --batch --keyserver "hkps://keys.openpgp.org" --recv-keys "$key" || \
        gpg --batch --keyserver "keyserver.ubuntu.com" --recv-keys "$key" ; \
    done && \
    gpg --verify /tmp/$QD_NAME.tar.gz.sha256.asc /tmp/$QD_NAME.tar.gz.sha256 && \
    (cd /tmp && sha256sum --check --status $QD_NAME.tar.gz.sha256) && \
    mkdir -p /tmp/qd && tar -xzf /tmp/$QD_NAME.tar.gz --directory /tmp/qd --strip-components=1 && \
    mv /tmp/qd/qodana-QD* $QODANA_DIST && \
    chmod +x $QODANA_DIST/bin/*.sh $QODANA_DIST/bin/qodana && \
    update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 0 && \
    update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 0 && \
    update-alternatives --set java $JAVA_HOME/bin/java && \
    update-alternatives --set javac $JAVA_HOME/bin/javac && \
    apt-get purge --auto-remove -y gnupg2 && \
    rm -rf /var/cache/apt /var/lib/apt/ /tmp/* $GNUPGHOME

LABEL maintainer="qodana-support@jetbrains.com" description="Qodana Community for Python (https://jb.gg/qodana-python-community)"
WORKDIR /data/project
ENTRYPOINT ["/opt/idea/bin/qodana"]