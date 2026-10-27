# Dotfiles

## About

```
├── bin         # general purpose utilities, added to PATH
├── config      # configuration files
├── docs        # documentation (README.md)
├── scripts     # repository-specific scripts
└── secrets     # secrets and ssh keys
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
