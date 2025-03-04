FROM debian:11-slim

ARG DEBIAN_FRONTEND=noninteractive
RUN \
  apt-get update && \
  apt-get install -y \
    bison \
    build-essential \
    cmake \
    flex \
    git \
    protobuf-compiler \
    libgnutls28-dev \
    libarchive-dev \
    libprotobuf-dev \
    libprotoc-dev \
    liblzma-dev \
    zlib1g-dev \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

COPY . /src
WORKDIR /src
#RUN git submodule init && \
#    git submodule update && \
RUN    mkdir build && \
    cd build && \
    CC=gcc CXX=g++ cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    DESTDIR=build-root make install



FROM debian:11-slim

ARG DEBIAN_FRONTEND=noninteractive

ARG USERNAME
ARG USERID
ARG GROUPID

RUN \
  apt-get update && \
  apt-get install -y libprotobuf23 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

# Добавляем пользователя
RUN groupadd --gid $GROUPID $USERNAME && \
    useradd --uid $USERID --gid $GROUPID -m $USERNAME

COPY --from=0 /src/build/build-root/ /

EXPOSE 6969
USER $USERNAME

#ENTRYPOINT ["/usr/bin/hefurd", "-http-port", "6969", "-udp-port", "0", "-https-port", "0", "-torrent-dir", "/torrents", "-scan-interval", "60", "-max-peers", "1024", "-allow-proxy", "-log-level", "info", "-log-file", "/tmp/hefur.log", "-min-numwant", "2000", "-max-numwant", "2000"]
ENTRYPOINT ["/usr/bin/hefurd", "-http-port", "6969", "-udp-port", "0", "-https-port", "0", "-torrent-dir", "/torrents", "-scan-interval", "60", "-max-peers", "1024", "-allow-proxy", "-log-level", "warning", "-min-numwant", "2000", "-max-numwant", "2000"]
