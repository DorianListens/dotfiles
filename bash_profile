if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

export PATH="~/.bin:$PATH"
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias vi=vim
alias gclean='git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
export PATH="/usr/local/opt/node@6/bin:$PATH"

export P4CONFIG=.p4config

PATH=$PATH:/Users/dscheidt/Library/Developer/Xamarin/android-sdk-macosx/platform-tools/


export PATH="$HOME/.cargo/bin:$PATH"
