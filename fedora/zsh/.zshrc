# ~/.zshrc

# autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# History
HISTFILE=~/.histfile
SAVEHIST=10000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Shell options
setopt beep extendedglob nomatch prompt_subst
unsetopt autocd notify

# Key Bindings (Emacs-like by default; remove or modify as needed)
bindkey -e  # Emacs mode
bindkey "^[[A" history_search_backward
bindkey "^[[B" history_search_forward
bindkey "^H" backward-kill-word
bindkey "^[[3~" delete-char        # Delete key
bindkey "^[[H" beginning-of-line   # Home key
bindkey "^[[F" end-of-line         # End key
bindkey "^[[1;5D" backward-word    # Ctrl+Left
bindkey "^[[1;5C" forward-word     # Ctrl+Right
bindkey "^[[3;5~" kill-word        # Ctrl+Delete

# Completion
autoload -Uz compinit
zstyle :compinstall filename "$HOME/.zshrc"
if [[ -s "$ZDOTDIR/.zcompdump" && "$ZDOTDIR/.zcompdump" -nt "$ZDOTDIR/.zshrc" ]]; then
  compinit
else
  compinit -C
fi

# Color Definitions
teal="%F{38}"
blue="%F{39}"
green="%F{43}"
red="%F{196}"
pink="%F{205}"
yellow="%F{226}"
matrix_green="%F{46}"
tokyo_purple="%F{141}"
reset="%f"
bold="%B"
normal="%b"

# Prompt Info Function
prompt_info() {
  local curPath="${PWD/#$HOME/~}"
  local user="$USER"
  local prompt_string="${green}󰀉 ${user}${reset}${yellow} on ${blue}${curPath}${reset}"

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local git_branch
    git_branch=$(git branch --show-current 2>/dev/null)
    if [[ -n "$git_branch" ]]; then
      local stash_count
      stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
      prompt_string+=" ${red}(${green}${git_branch}${red})${reset}"
      if (( stash_count > 0 )); then
        prompt_string+=" ${yellow}⚑${stash_count}${reset}"
      fi
    fi
  fi

  echo "${prompt_string}\n${pink}\$: ${reset}"
}

# Dynamic Prompt Setup
update_prompt() {
  local venv_prefix=""
  if [[ -n "$VIRTUAL_ENV" ]]; then
    venv_prefix="${matrix_green}($(basename "$VIRTUAL_ENV")) ${reset}"
  fi

  PROMPT="${venv_prefix}\$(prompt_info)"
}

# Hook: Update prompt before each new command
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_prompt

# Initial Prompt Setup
update_prompt

# Aliases
alias ls='ls --color=auto'
alias c='clear'
alias vim='nvim'
alias vi='nvim'
alias v="nvim"
alias diff="diff --color"

# Window Manager (Commented to avoid shell termination)
if command -v uwsm &>/dev/null && uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi

# Root prompt handling
if [[ $UID -eq 0 ]]; then
  PROMPT='$(prompt_info)'  # Skip venv for root user
fi

export TURTLEBOT3_MODEL=burger
export PATH="$HOME/local/nvim/bin:$PATH"
