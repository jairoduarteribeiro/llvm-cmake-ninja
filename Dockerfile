FROM ubuntu:22.04

ENV LLVM_VERSION=18

ENV PATH=/usr/lib/llvm-$LLVM_VERSION/bin:$PATH

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg \
        lsb-release \
        software-properties-common \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget --no-check-certificate -O /tmp/llvm.sh https://apt.llvm.org/llvm.sh && \
    chmod +x /tmp/llvm.sh && \
    /tmp/llvm.sh $LLVM_VERSION all && \
    rm /tmp/llvm.sh
