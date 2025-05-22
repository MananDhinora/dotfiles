# ~/.zshrc

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000

# Shell options
setopt beep extendedglob nomatch prompt_subst
unsetopt autocd notify

# Use Vim keybindings
bindkey -v

# Key Bindings
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

# Vim mode indicator
zle-keymap-select() {
  case $KEYMAP in
    vicmd) VIMODE="${red}${bold}[N]${normal}${reset}" ;;   # Normal mode
    main|viins) VIMODE="${tokyo_purple}${bold}[I]${normal}${reset}" ;;  # Insert mode
    *) VIMODE="${yellow}[?]${reset}" ;;  # Unknown mode
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

# Also catch on line init
zle-line-init() {
  VIMODE="${green}${bold}[I]${normal}${reset}"  # Default mode
  zle reset-prompt
}
zle -N zle-line-init

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

  echo "${prompt_string}\n${VIMODE} ${pink}\$: ${reset}"
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

# Window Manager (Commented to avoid shell termination)
if command -v uwsm &>/dev/null && uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi

# Root prompt handling
if [[ $UID -eq 0 ]]; then
  PROMPT='$(prompt_info)'  # Skip venv for root user
fi
