ARG DOTNET_BASE_TAG="7.0-bullseye-slim"
FROM mcr.microsoft.com/dotnet/sdk:$DOTNET_BASE_TAG

# renovate: datasource=repology depName=debian_11/ca-certificates versioning=loose
ENV CA_CERTIFICATES_VERSION="20210119"
# renovate: datasource=repology depName=debian_11/curl versioning=loose
ENV CURL_VERSION="7.74.0-1.3+deb11u12"
# renovate: datasource=repology depName=debian_11/git versioning=loose
ENV GIT_VERSION="1:2.30.2-1+deb11u2"
# renovate: datasource=repology depName=debian_11/git-lfs versioning=loose
ENV GIT_LFS_VERSION="2.13.2-1+b5"
# renovate: datasource=repology depName=debian_11/gnupg2 versioning=loose
ENV GNUPG2_VERSION="2.2.27-2+deb11u2"
# renovate: datasource=repology depName=debian_11/default-jre versioning=loose
ENV DEFAULT_JRE_VERSION="2:1.11-72"
# renovate: datasource=repology depName=debian_11/locales versioning=loose
ENV LOCALES_VERSION="2.31-13+deb11u10"

ENV HOME="/root" \
    LC_ALL="en_US.UTF-8" \
    QODANA_DATA="/data" \
    QODANA_DOCKER="true" \
    PATH="/opt/qodana:${PATH}"

ENV DOTNET_ROOT="/usr/share/dotnet"

# Not using the URL https://dot.net/v1/dotnet-install.sh because of https://github.com/dotnet/install-scripts/issues/276
ARG DOTNET_INSTALL_SH_REVISION="40434288dc5bbda41eafcbcbbc5c0fbbe028fb30"
ARG DOTNET_CHANNEL_A="7.0"
ARG DOTNET_CHANNEL_B="6.0"
ARG DOTNET_CHANNEL_C="8.0"

# hadolint ignore=SC2174,DL3009
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    mkdir -m 777 -p /opt/qodana /data/project /data/cache /data/results && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates=$CA_CERTIFICATES_VERSION \
        curl=$CURL_VERSION \
        default-jre=$DEFAULT_JRE_VERSION \
        git=$GIT_VERSION \
        git-lfs=$GIT_LFS_VERSION \
        gnupg2=$GNUPG2_VERSION \
        locales=$LOCALES_VERSION && \
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen && \
    apt-get autoremove -y && apt-get clean && \
    curl -fsSL -o /tmp/dotnet-install.sh  \
         "https://raw.githubusercontent.com/dotnet/install-scripts/$DOTNET_INSTALL_SH_REVISION/src/dotnet-install.sh" && \
    echo "d9ede6126a6da49cd3509e5fc8236f79addf175696f29d01f38840fd84663514 /tmp/dotnet-install.sh" > /tmp/shasum && \
    if [ "${DOTNET_INSTALL_SH_REVISION}" != "master" ]; then sha256sum --check --status /tmp/shasum; fi && \
    chmod +x /tmp/dotnet-install.sh && \
    bash /tmp/dotnet-install.sh -c $DOTNET_CHANNEL_A -i $DOTNET_ROOT && \
    bash /tmp/dotnet-install.sh -c $DOTNET_CHANNEL_B -i $DOTNET_ROOT && \
    bash /tmp/dotnet-install.sh -c $DOTNET_CHANNEL_C -i $DOTNET_ROOT && \
    chmod 777 -R $DOTNET_ROOT && \
    chmod 777 -R $HOME && \
    echo 'root:x:0:0:root:/root:/bin/bash' > /etc/passwd && chmod 666 /etc/passwd && \
    git config --global --add safe.directory '*'

RUN apt-get update && \
    apt-get install -y sudo && \
    useradd -m -u 1001 -U qodana && \
    passwd -d qodana && \
    echo 'qodana ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ARG QD_RELEASE="2024.2"
ARG QD_BUILD="QDNETC-$QD_RELEASE"
# hadolint ignore=DL3003,SC2043
RUN set -ex && \
    dpkgArch="$(dpkg --print-architecture)" && \
    case "$dpkgArch" in \
        "amd64") \
            OS_ARCH_SUFFIX=""; \
            ;; \
        "arm64") \
            OS_ARCH_SUFFIX="-aarch64"; \
            ;; \
        *) echo "Unsupported architecture $dpkgArch" >&2; exit 1 ;; \
    esac && \
    QD_NAME="qodana-$QD_BUILD$OS_ARCH_SUFFIX" \
    QD_URL="https://download.jetbrains.com/qodana/$QD_RELEASE/$QD_NAME.tar.gz" && \
    curl -fsSL "$QD_URL" -o "/tmp/$QD_NAME.tar.gz" \
               "$QD_URL.sha256" -o "/tmp/$QD_NAME.tar.gz.sha256" \
               "$QD_URL.sha256.asc" -o "/tmp/$QD_NAME.tar.gz.sha256.asc" && \
    GNUPGHOME="$(mktemp -d)" && \
    export GNUPGHOME && \
    for key in \
        "B46DC71E03FEEB7F89D1F2491F7A8F87B9D8F501" \
      ; do \
        gpg --batch --keyserver "hkps://keys.openpgp.org" --recv-keys "$key" || \
        gpg --batch --keyserver "keyserver.ubuntu.com" --recv-keys "$key" ; \
    done && \
    gpg --verify "/tmp/$QD_NAME.tar.gz.sha256.asc" "/tmp/$QD_NAME.tar.gz.sha256" && \
    (cd /tmp && sha256sum --check --status "$QD_NAME.tar.gz.sha256") && \
    mkdir -p /tmp/qd && tar -xzf "/tmp/$QD_NAME.tar.gz" --directory /opt/qodana  && \
    mv /opt/qodana/qodana-cdnet /opt/qodana/qodana && \
    chmod +x /opt/qodana/qodana && \
    apt-get purge --auto-remove -y gnupg2 && \
    rm -rf /var/cache/apt /var/lib/apt/ /tmp/* "$GNUPGHOME"

ENV PATH="/opt/qodana:${PATH}"

LABEL maintainer="qodana-support@jetbrains.com" description="Qodana Community for .NET"
WORKDIR /data/project
ENTRYPOINT ["qodana", "scan"]
