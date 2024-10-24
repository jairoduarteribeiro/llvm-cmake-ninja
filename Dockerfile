FROM buildpack-deps:bookworm

RUN groupadd --gid 1000 dev && \
    useradd --uid 1000 --gid dev --shell /bin/bash --create-home dev

ENV LLVM_VERSION=18 \
    CMAKE_VERSION=3.30.5 \
    NINJA_VERSION=1.12.1

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        lsb-release \
        software-properties-common; \
    wget --no-check-certificate -O /tmp/llvm.sh https://apt.llvm.org/llvm.sh; \
    chmod +x /tmp/llvm.sh; \
    /tmp/llvm.sh $LLVM_VERSION all; \
    rm /tmp/llvm.sh; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) cmakeFile="cmake-$CMAKE_VERSION-linux-x86_64.tar.gz";; \
        arm64) cmakeFile="cmake-$CMAKE_VERSION-linux-aarch64.tar.gz";; \
        *) echo "Unsupported architecture"; exit 1;; \
    esac; \
    wget --no-check-certificate -O /tmp/cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/$cmakeFile; \
    tar -xzf /tmp/cmake.tar.gz -C /usr --strip-components=1; \
    rm /tmp/cmake.tar.gz

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) ninjaFile="ninja-linux.zip";; \
        arm64) ninjaFile="ninja-linux-aarch64.zip";; \
        *) echo "Unsupported architecture"; exit 1;; \
    esac; \
    wget --no-check-certificate -O /tmp/ninja.zip https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/$ninjaFile; \
    unzip /tmp/ninja.zip -d /usr/bin; \
    rm /tmp/ninja.zip

ENV PATH=/usr/lib/llvm-$LLVM_VERSION/bin:$PATH \
    LD_LIBRARY_PATH=/usr/lib/llvm-$LLVM_VERSION/lib \
    CC=clang \
    CXX=clang++ \
    CXXFLAGS="-stdlib=libc++" \
    LDFLAGS="-lc++abi" \
    CMAKE_GENERATOR=Ninja
