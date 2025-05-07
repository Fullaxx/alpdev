# ------------------------------------------------------------------------------
# Pull base image
FROM alpine:latest
LABEL author="Brett Kuskie <fullaxx@gmail.com>"

# ------------------------------------------------------------------------------
# Set environment variables
ENV QLIBCVERS="2.5.0"
ENV QLIBCURL="https://github.com/wolkykim/qlibc/archive/refs/tags/v${QLIBCVERS}.tar.gz"

# ------------------------------------------------------------------------------
# Create a docker image suitable for development
# TODO: FIXME: apcalc hping3 lbzip2 pbzip2 plzip
RUN apk update && \
    apk add --no-cache \
      alpine-sdk \
      bash bash-completion \
      build-base \
      ca-certificates \
      cgdb \
      cmake \
      curl curl-dev curl-static \
      dtach \
      doxygen \
      file \
      gdb \
      git \
      hiredis-dev \
      iproute2 \
      iputils \
      jq \
      less \
      libcurl \
      libevent-dev libevent-static \
      libgcrypt-dev libgcrypt-static \
      libmicrohttpd-dev libmicrohttpd-static \
      libnet-dev libnet-static \
      libpcap-dev \
      libwebsockets-dev \
      libxml2-dev libxml2-static \
      zeromq-dev libzmq-static \
      lsof \
      meson \
      nano \
      net-tools \
      ninja \
      openssh-client \
      openssl-dev openssl-libs-static \
      pigz \
      pixz \
      pv \
      rsync \
      screen \
      sqlite sqlite-dev sqlite-static \
      sshfs \
      supervisor \
      tcpdump \
      tmux \
      tree \
      tshark \
      unzip \
      vim \
      zip \
      zlib-dev zlib-static && \
    rm -rf /var/cache/apk/*

# ------------------------------------------------------------------------------
# Install python modules and clean up
RUN apk add --no-cache python3 py3-pip && \
    python3 -m pip install --no-cache-dir --break-system-packages \
      ipython \
      grip \
      pandas==2.1.4 \
      pudb \
      pyzmq \
      redis[hiredis] \
      rel \
      scapy \
      websocket-client \
      wsaccel \
      xxhash && \
    rm -rf /var/cache/apk/*

# ------------------------------------------------------------------------------
# Install qlibc
RUN cd /tmp && \
    curl -L ${QLIBCURL} -o qlibc-${QLIBCVERS}.tar.gz && \
    tar xf qlibc-${QLIBCVERS}.tar.gz && cd qlibc-${QLIBCVERS} && \
    ./configure --prefix=/usr --libdir=/usr/lib && make && make install && cd /tmp && \
    rm -rf qlibc-${QLIBCVERS} qlibc-${QLIBCVERS}.tar.gz && (ldconfig || true)

# ------------------------------------------------------------------------------
# Define default command
CMD ["/bin/sh"]
