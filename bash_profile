if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

export PATH="~/.bin:$PATH"
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias vi=vim
alias gclean='git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'
