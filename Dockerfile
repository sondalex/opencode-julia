FROM ghcr.io/sondalex/opencode-xdgopen:debian

ARG JULIA_VERSION=1.10.5
ARG JULIA_MAJOR_MINOR=1.10

# The base image is Alpine (musl) despite its tag; glibc Julia needs a compat layer.
USER root
RUN apk add --no-cache gcompat libstdc++ libgcc

RUN ARCH=$(uname -m) \
  && case "$ARCH" in \
       x86_64) JULIA_ARCH="x86_64"; JULIA_DIR="x64" ;; \
       aarch64) JULIA_ARCH="aarch64"; JULIA_DIR="aarch64" ;; \
       *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
     esac \
  && curl -fsSL "https://julialang-s3.julialang.org/bin/linux/${JULIA_DIR}/${JULIA_MAJOR_MINOR}/julia-${JULIA_VERSION}-linux-${JULIA_ARCH}.tar.gz" -o /tmp/julia.tar.gz \
  && mkdir -p /opt/julia \
  && tar -xzf /tmp/julia.tar.gz -C /opt/julia --strip-components=1 \
  && rm /tmp/julia.tar.gz \
  && ln -s /opt/julia/bin/julia /usr/local/bin/julia

ENV PATH="/opt/julia/bin:${PATH}"

RUN julia --version
