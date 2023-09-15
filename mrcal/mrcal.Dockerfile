ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

# Tweak APT configuration
RUN \
    # Don't install recommended pkgs
    echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > \
        /etc/apt/apt.conf.d/01norecommend \
    # Assume `-y`
    && echo 'APT::Get::Assume-Yes "true";' > \
        /etc/apt/apt.conf.d/02assumeyes \
    # Keep APT package cache
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
        > /etc/apt/apt.conf.d/03keep-cache \
    && echo 'APT::Clean-Installed "false";' \
        > /etc/apt/apt.conf.d/04clean-installed-off \
    && rm -f /etc/apt/apt.conf.d/docker-clean

ARG DEBIAN_FRONTEND=noninteractive

RUN echo 'deb [trusted=yes] http://mrcal.secretsauce.net/packages/jammy/public/ jammy main' >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y sudo \
    zsh \
    locales\
    mrcal \
    libmrcal-dev \ 
    python3-mrcal \
    mrgingham \
    vim \
    x11-apps \
    git

#==
# Locale
#==
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

ARG _UID
ARG _GID
ARG USER
# check if UID and GID already exists in container if not then set username's IDs to the ones from host
RUN if ! id -u ${USER} >/dev/null 2>&1; then useradd -u ${_UID} -s /bin/bash -m ${USER}; fi && \
    if ! getent group ${_GID} >/dev/null 2>&1; then groupmod -g ${_GID} ${USER}; fi && \
    usermod -a -G ${USER} ${USER} && \
    usermod -a -G video ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chown -R ${USER}:${USER} /root

USER ${USER}
WORKDIR "/home/${USER}"
CMD /bin/bash
