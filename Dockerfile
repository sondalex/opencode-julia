FROM ghcr.io/sondalex/opencode-xdgopen:latest

ENV JULIAUP_DEPOT_PATH=/opt/julia
ENV PATH="/root/.juliaup/bin:${PATH}"

RUN curl -fsSL https://install.julialang.org | sh -s -- --yes

RUN julia --version
