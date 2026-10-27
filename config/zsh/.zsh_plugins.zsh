fpath+=( "$HOME/.local/share/antidote/github.com/getantidote/use-omz" )
source "$HOME/.local/share/antidote/github.com/getantidote/use-omz/use-omz.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib" )
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/async_prompt.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/bzr.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/cli.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/clipboard.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/compfix.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/completion.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/correction.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/diagnostics.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/directories.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/functions.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/git.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/grep.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/history.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/key-bindings.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/misc.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/nvm.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/prompt_info_functions.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/spectrum.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/termsupport.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/theme-and-appearance.zsh"
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/lib/vcs_info.zsh"
if ! (( $+functions[zsh-defer] )); then
  fpath+=( "$HOME/.local/share/antidote/github.com/romkatv/zsh-defer" )
  source "$HOME/.local/share/antidote/github.com/romkatv/zsh-defer/zsh-defer.plugin.zsh"
fi
fpath+=( "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/chezmoi" )
zsh-defer source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/chezmoi/chezmoi.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/extract" )
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/extract/extract.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/fzf" )
zsh-defer source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/fzf/fzf.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/herdr" )
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/herdr/herdr.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/mise" )
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/mise/mise.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/ssh" )
zsh-defer source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/ssh/ssh.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/ssh-agent" )
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/ssh-agent/ssh-agent.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/tmux" )
source "$HOME/.local/share/antidote/github.com/ohmyzsh/ohmyzsh/plugins/tmux/tmux.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/color" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/color/color.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/completion" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/completion/completion.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/compstyle" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/compstyle/compstyle.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/editor" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/editor/editor.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/environment" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/environment/environment.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/history" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/history/history.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/homebrew" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/homebrew/homebrew.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/macos" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/macos/macos.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/utility" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/utility/utility.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/zfunctions" )
source "$HOME/.local/share/antidote/github.com/mattmc3/zephyr/plugins/zfunctions/zfunctions.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/paulirish/git-open" )
source "$HOME/.local/share/antidote/github.com/paulirish/git-open/git-open.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/zdharma-continuum/fast-syntax-highlighting" )
zsh-defer source "$HOME/.local/share/antidote/github.com/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fpath+=( "$HOME/.local/share/antidote/github.com/zsh-users/zsh-completions/src" )
