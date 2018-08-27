# CLI Environment Dotfiles for Linux

Covers configurations for the following CLI tools:

- bash
- git
- tmux
- vim

This script is mostly tested on Ubuntu, and works with the latest version
(18.04).

## Preparation

The following APT packages are *required*:

- git
- tig
- vim
- tmux
- curl

The following APT packages are *recommended*:

- python3
- python3-pip
- fonts-powerline
- exuberant-ctags

```bash
sudo apt install -y git tig vim tmux curl python3 python3-pip fonts-powerline exuberant-ctags
```

## Usage

The script is simple and interactive. Just follow the prompts.

```bash
./install.sh
```

