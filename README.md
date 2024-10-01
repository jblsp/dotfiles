# dotfiles

## Tools
- [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- [Alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
- [Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Github CLI](https://github.com/cli/cli#installation)
- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh?tab=readme-ov-file#prerequisites)
- [Meslo Nerd Font patched for Powerlevel10k](https://github.com/romkatv/powerlevel10k/blob/master/font.md)

## Set up repo on $HOME

```shell
# Install the repo
sh -c "$(curl -fsSL https://raw.githubusercontent.com/jblsp/dotfiles/main/install.sh)"

# You may need to give yourself ownership over the repository
sudo chown -R $(whoami) $HOME/.cfggit
```
