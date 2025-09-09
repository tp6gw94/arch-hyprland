eval "$(zellij setup --generate-auto-start zsh)"

FUNCNEST=1000

xset r rate 200 10

bindkey "^[[1;3D" backward-word  # Alt + 左箭頭
bindkey "^[[1;3C" forward-word   # Alt + 右箭頭
bindkey "^[^[[D" backward-word   # Alt + 左箭頭
bindkey "^[^[[C" forward-word    # Alt + 右箭頭

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(~/.local/bin/mise activate zsh)"

alias pn="pnpm"
alias lg="lazygit"
alias ld="lazydocker"
alias so="source ~/.config/.zshrc"
alias note="zk edit -i -W $HOME/docs"
alias n="nvim"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export HYPRSHOT_DIR="~/screenshots"
export EDITOR="nvim"
export PATH="$HOME/zk:$PATH"
export BAT_THEME="base16-256"
export FZF_DEFAULT_OPTS='--color=bg+:#ffffff,fg+:#000000,hl+:#0066cc'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit light zsh-users/zsh-completions
zinit light rupa/z
zinit light zsh-users/zsh-history-substring-search

zinit ice wait"1"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"2"
zinit light zsh-users/zsh-syntax-highlighting
