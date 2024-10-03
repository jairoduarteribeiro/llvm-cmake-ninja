
# llvm-cmake-ninja

This project provides a Docker image based on **Ubuntu 22.04**, which includes **LLVM**, **CMake**, and **Ninja** pre-installed. This image is designed to provide an easy-to-use environment for building C++ projects that rely on these tools.

## Docker Image

The image is available on [Docker Hub](https://hub.docker.com/r/jairoduarteribeiro/llvm-cmake-ninja).

## Features

- **LLVM**: Complete LLVM toolchain, including Clang and LLD.
- **CMake**: A cross-platform build system for managing and automating builds.
- **Ninja**: A small and fast build system that generates builds quickly.

## Usage

To pull the Docker image from Docker Hub, use the following command:

```bash
docker pull jairoduarteribeiro/llvm-cmake-ninja
```

To run a container using this image, execute:

```bash
docker run -it jairoduarteribeiro/llvm-cmake-ninja
```

You can mount a volume to your local project directory for building inside the container:

```bash
docker run -it -v /path/to/your/project:/workspace jairoduarteribeiro/llvm-cmake-ninja
```

Once inside the container, navigate to the mounted directory `/workspace` and use **CMake** and **Ninja** to build your project:

```bash
cd /workspace
cmake -B build -S . -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
cmake --build build
```

## Note

This image includes a non-root user called `dev`.
