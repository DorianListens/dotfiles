if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

export PATH="~/.bin:$PATH"
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias vi=vim
alias gclean='git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
