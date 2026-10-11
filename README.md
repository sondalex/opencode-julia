# opencode-julia

OpenCode container image for Julia development, built on top of [opencode-xdgopen](https://github.com/sondalex/opencode-xdgopen) (`:debian` tag, which is actually Alpine/musl-based; `gcompat` is installed so the glibc Julia build runs).

**This is an independent project and is not affiliated with or endorsed by OpenCode**.

This image inherits from `ghcr.io/sondalex/opencode-xdgopen:debian` and adds Julia.

## Why not `juliaup`?

`juliaup`'s launcher crashes ("Juliaup launcher had a problem and crashed")
when run inside Podman/Docker, even on a glibc base. This is caused by the
container's restricted seccomp profile blocking syscalls the launcher relies
on.

Instead, Julia is installed directly from the official **glibc Linux**
build published by JuliaLang (Tier 1 supported platform), avoiding the
juliaup launcher entirely:

```
https://julialang-s3.julialang.org/bin/linux/<arch>/<major.minor>/julia-<version>-linux-<arch>.tar.gz
```

The Julia version is pinned via the `JULIA_VERSION` / `JULIA_MAJOR_MINOR`
build args, e.g.:

```bash
podman build \
  --build-arg JULIA_VERSION=1.10.5 \
  --build-arg JULIA_MAJOR_MINOR=1.10 \
  -t ghcr.io/sondalex/opencode-julia:<tag> .
```

## Usage

For convenience, add this command to your `~/.zshrc`

```bash
opencode-julia() {
    podman run -it --rm \
        -v "$(pwd)":/workspace:Z \
        -v "${XDG_CONFIG_HOME:-$HOME/.config}/opencode":/root/.config/opencode:Z \
        -v "${XDG_DATA_HOME:-$HOME/.local/share}/opencode":/root/.local/share/opencode:Z \
        -v "${XDG_STATE_HOME:-$HOME/.local/state}/opencode":/root/.local/state/opencode:Z \
        -w /workspace \
        ghcr.io/sondalex/opencode-julia "$@"
}
```

## Development

Build

```bash
podman build -t ghcr.io/sondalex/opencode-julia:<tag> .
```

Publish

```bash
echo $GH_TOKEN | podman login ghcr.io -u <user> --password-stdin
```

```bash
podman push ghcr.io/sondalex/opencode-julia:<tag>
```
