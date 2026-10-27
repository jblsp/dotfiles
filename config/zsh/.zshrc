# ohmyzsh/ssh-agent
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent quiet yes

# zephyr/editor
zstyle ':zephyr:plugin:editor:*' cursor 'block'

# fzf
fzf_opts=(
  '--color=16'           # Use terminal's 16-color ANSI palette
  '--color=bg:-1,bg+:-1' # Use terminal background for all rows
  '--color=fg:-1,fg+:-1' # Use terminal foreground for all rows
  '--color=hl:12,hl+:12' # Use ANSI accent color for matches
  '--color=info:8'       # Use ANSI gray for match information
  '--color=prompt:12'    # Use ANSI accent color for search prompt
  '--color=pointer:12'   # Use ANSI accent color for selection pointer
  '--color=marker:12'    # Use ANSI accent color for selection markers
  '--color=spinner:12'   # Use ANSI accent color for loading spinner
  '--color=header:-1'    # Use terminal foreground for header text
  '--color=border:8'     # Use ANSI gray for borders
  '--height=40%'         # Occupy 40% of terminal height
  '--layout=reverse'     # Display search prompt at the top
  '--border'             # Draw a border around the interface
)
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }${(j: :)fzf_opts}"

# antidote
ANTIDOTE_HOME=${XDG_DATA_HOME}/antidote
if [[ ! -e ${ANTIDOTE_HOME}/antidote.zsh ]]; then
  command git clone --depth=1 https://github.com/mattmc3/antidote.git ${ANTIDOTE_HOME}
fi
source ${ANTIDOTE_HOME}/antidote.zsh
antidote load

# fast-syntax-highlighting loads through zsh-defer.
zsh-defer -c '[[ $FAST_THEME_NAME == base16 ]] || fast-theme -q base16'

# aliases
alias sudo="sudo "
alias vi="nvim"

# main opts
setopt globdots             # Include hidden files in glob patterns
setopt no_case_match        # Make pattern matching case-insensitive
unsetopt prompt_sp          # Don't preserve partial lines when output lacks a final newline

# history opts
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh/zsh_history"

# load oh-my-posh
if (( $+commands[oh-my-posh] )); then
  eval "$(oh-my-posh init zsh --config pure)"
fi

# vim: ft=zsh
