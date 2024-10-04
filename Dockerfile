FROM ubuntu:22.04

ARG TARGETARCH
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV LLVM_VERSION=18
ENV CMAKE_VERSION=3.30.4
ENV NINJA_VERSION=1.12.1

ENV PATH=/usr/lib/llvm-$LLVM_VERSION/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib/llvm-$LLVM_VERSION/lib:$LD_LIBRARY_PATH

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg \
        lsb-release \
        software-properties-common \
        unzip \
        wget && \
    wget --no-check-certificate -O /tmp/llvm.sh https://apt.llvm.org/llvm.sh && \
    chmod +x /tmp/llvm.sh && \
    /tmp/llvm.sh $LLVM_VERSION all && \
    rm /tmp/llvm.sh && \
    if [ "$TARGETARCH" = "arm64" ]; then \
        wget --no-check-certificate -O /tmp/cmake.sh https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-linux-aarch64.sh && \
        wget --no-check-certificate -O /tmp/ninja.zip https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/ninja-linux-aarch64.zip; \
    elif [ "$TARGETARCH" = "amd64" ]; then \
        wget --no-check-certificate -O /tmp/cmake.sh https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-linux-x86_64.sh && \
        wget --no-check-certificate -O /tmp/ninja.zip https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/ninja-linux.zip; \
    else \
        echo "Unsupported architecture: $TARGETARCH"; \
        exit 1; \
    fi && \
    chmod +x /tmp/cmake.sh && \
    /tmp/cmake.sh --skip-license --prefix=/usr && \
    rm /tmp/cmake.sh && \
    unzip /tmp/ninja.zip -d /usr/bin && \
    rm /tmp/ninja.zip && \
    apt-get remove -y --purge \
        gnupg \
        lsb-release \
        software-properties-common \
        unzip \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME

ENV CC=clang
ENV CXX=clang++

ENV CXXFLAGS="-stdlib=libc++"
ENV LDFLAGS="-lc++abi"

ENV CMAKE_GENERATOR=Ninja
