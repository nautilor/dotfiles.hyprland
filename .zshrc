# Theme
ZSH_THEME="flazz"
CATPPUCCIN_FLAVOR="mocha"

# Plugins
plugins=(git zsh-sdkman)

# set the home for oh-my-zsh
export ZSH="/home/edoardo/.oh-my-zsh"

# initialize oh my zsh with better highlighting
source $ZSH/oh-my-zsh.sh
source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# nvim
export EDITOR=nvim
alias vim=nvim
alias n=nvim

# Android
export ANDROID_HOME=$HOME/.android/sdk
export ANDROID_SDK_ROOT=$HOME/.android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:/opt/android-studio/bin


# jdtls
export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/java/lombok.jar"


# Rust
export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin

# Go
export GO_HOME=.go

# FZF
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_CTRL_T_OPTS="--preview ' eza --tree --color=always {} | head -200'"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
eval "$(fzf --zsh)"

# Make sure that fzf uses eza and bat
_fzf_comprun() {
	local command=$1
	shift

	case "$command" in
		cd) 		fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
		export|unset) 	fzf --preview "eval 'echo \$' {}" "$@" ;;
		*)		fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" "$@" ;;
	esac
}


# ssh
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Some server might not have xter-kitty so default to xterm-256color
function ssh {
	export TERM=xterm-256color
	/usr/bin/ssh "$@"
}

# tmux
alias ta='TERM=xterm-kitty tmux a'
alias tmux='TERM=xterm-kitty tmux'
function t {
	TERM="xterm-kitty"
	[[ `tmux ls 2>/dev/null | grep -E "^main:.*"` ]] && tmux || tmux new -s main
}


# Spotify
export PATH=$PATH:/home/edoardo/.spicetify

# zoxide
eval "$(zoxide init zsh)"

# Replace ls with eza
alias ls=eza
alias l=eza
alias lr="ls -R"
alias c='clear'

# Restart waybar
alias waykill='killall waybar && waybar_top'

# LazyGit
alias lg=lazygit

# Yazi file manager
alias y=yazi

# This is used to initialize sdkman / please keep it at the end of file
export SDKMAN_DIR="$HOME/.sdkman"
local old_sdkman_offline_mode=${SDKMAN_OFFLINE_MODE:-}
export SDKMAN_OFFLINE_MODE=true
source "$SDKMAN_DIR/bin/sdkman-init.sh"

if [[ -n $old_sdkman_offline_mode ]]; then
    export SDKMAN_OFFLINE_MODE=$old_sdkman_offline_mode
else
    unset SDKMAN_OFFLINE_MODE
fi
unset old_sdkman_offline_mode
