# opencode-julia

OpenCode container image for Julia development, built on top of [opencode-xdgopen](https://github.com/sondalex/opencode-xdgopen) (`:debian` tag, glibc-based).

**This is an independent project and is not affiliated with or endorsed by OpenCode**.

This image inherits from `ghcr.io/sondalex/opencode-xdgopen:debian` and adds
Julia, installed via the official [juliaup](https://github.com/JuliaLang/juliaup)
installer.

## Why glibc instead of Alpine/musl?

- Julia's musl (Alpine) build is Tier 4 support upstream and is currently
  known not to build/run correctly.
- `juliaup`'s prebuilt launcher is also glibc-only and crashes on musl.

So this image is based on the Debian-based (`:debian`) variant of
`opencode-xdgopen` rather than the default Alpine-based image.

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
