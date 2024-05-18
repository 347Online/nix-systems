fpath=(~/.config/zsh/completions $fpath)
autoload -U compinit
compinit

test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
eval "$(fzf --zsh)"

HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups