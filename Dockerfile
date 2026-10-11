FROM ghcr.io/sondalex/opencode-xdgopen:latest

ARG JULIA_VERSION=1.10.5
ARG JULIA_MAJOR_MINOR=1.10

RUN apk add --no-cache gcompat libstdc++ \
  && ARCH=$(uname -m) \
  && case "$ARCH" in \
       x86_64) JULIA_DIR_ARCH="x64"; JULIA_FILE_ARCH="x86_64" ;; \
       aarch64) JULIA_DIR_ARCH="aarch64"; JULIA_FILE_ARCH="aarch64" ;; \
       *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
     esac \
  && curl -fsSL "https://julialang-s3.julialang.org/bin/musl/${JULIA_DIR_ARCH}/${JULIA_MAJOR_MINOR}/julia-${JULIA_VERSION}-musl-${JULIA_FILE_ARCH}.tar.gz" -o /tmp/julia.tar.gz \
  && mkdir -p /opt/julia \
  && tar -xzf /tmp/julia.tar.gz -C /opt/julia --strip-components=1 \
  && rm /tmp/julia.tar.gz \
  && ln -s /opt/julia/bin/julia /usr/local/bin/julia

RUN julia --version
