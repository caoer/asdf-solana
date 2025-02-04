<div align="center">

# asdf-solana [![Build](https://github.com/caoer/asdf-solana/actions/workflows/build.yml/badge.svg)](https://github.com/caoer/asdf-solana/actions/workflows/build.yml) [![Lint](https://github.com/caoer/asdf-solana/actions/workflows/lint.yml/badge.svg)](https://github.com/caoer/asdf-solana/actions/workflows/lint.yml)

[solana](https://github.com/anza-xyz/agave) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add solana
# or
asdf plugin add solana https://github.com/caoer/asdf-solana.git
```

solana:

```shell
# Show all installable versions
asdf list-all solana

# Install specific version
asdf install solana latest

# Set a version globally (on your ~/.tool-versions file)
asdf global solana latest

# Now solana commands are available
solana --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/caoer/asdf-solana/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Zitao Xiong](https://github.com/caoer/)
