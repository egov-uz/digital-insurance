<p align="center">
    <img src=".github/assets/header.png" alt="EGOV's {DI}">
</p>

<p align="center">
    <h3 align="center">Proposed Digital Insurance platform (MVP).</h3>
</p>

<p align="center">
    <img align="center" src="https://img.shields.io/github/languages/top/egov-uz/digital-insurance?style=flat&logo=rust&logoColor=3553B8&labelColor=ffffff&color=3553B8" alt="Top Used Language">
</p>

This is proposed Digital Insuranced project which aims to demnstrate what the final product (should) look like. The project includes conformance tool and implementation guide as well.

## Development

The project is a huge monorepo of monorepos (let's say megarepo) which consists of various components and each component has `shell.nix` which has development environment preconfigured already. Monorepo of monorepos merges every development environment and creates one big dev space. Just open your terminal and at the root of this project:

```bash
# Open in bash by default
nix develop

# If you want other shell
nix develop -c $SHELL

# After entering Nix development environment,
# inside the env, you can open your editor, so
# your editor will read all $PATH and environmental
# variables, also your terminal inside your editor
# will adopt all variables, so, you can close terminal.
```

## Building

Well, there are two ways of building your project. You can either go with classic `cargo build` or `pnpm build` way, but before that, make sure to enter development environment to have cargo and all rust toolchain available in your PATH, you may do like that:

```bash
# Entering development environment
nix develop -c $SHELL

# Enter any project
cd ./di-X

# Compile the project
cargo build --release # or pnpm build
```

Or, you can build your project via nix which will do all the dirty work for you. Just, in your terminal:

```bash
# Build in nix environment
nix build .#di-X

# Executable binary is available at:
./result/bin/di-X
```

## License

This project is dual licensed under the CC0-1.0 License - see the [LICENSE](LICENSE) file for details.

<p align="center">
  <img src=".github/assets/footer.png" alt="EGOV's {DI}">
</p>
