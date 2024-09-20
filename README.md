# dotfiles

## Set up repo on $HOME

```shell
sh -c "$(wget https://raw.githubusercontent.com/jblsp/dotfiles/main/install.sh -O -)" && alias config='/usr/bin/git --git-dir=$HOME/.cfggit/ --work-tree=$HOME'
```
