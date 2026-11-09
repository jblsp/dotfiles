# Dotfiles

## About

My personal dotfiles, compatible with MacOS/Linux, managed by [mise](https://mise.jdx.dev).

```
├── bin         # general purpose utilities, added to PATH
├── config      # configuration files
├── docs        # documentation (README.md)
├── scripts     # repository-specific scripts
└── secrets     # template secrets
```

## Setup

### Requirements

- [git](https://git-scm.com/install/)
- [mise](https://mise.jdx.dev/installing-mise.html)

### Install

Clone into `~/dotfiles` and bootstrap:

```sh
mise bootstrap --from https://github.com/jblsp/dotfiles.git \
  --from-dir <install-location>
```
