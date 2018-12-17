# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=9999
setopt appendhistory extendedglob
unsetopt autocd beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install

# Language setting
LANG=en_US.UTF-8

#
# Additional key bindings
#

# ctrl-left/right
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

# ctrl-backspace/delete
bindkey "\C-_" backward-kill-word
bindkey "\e[3;5~" kill-word

# alt-backspace
bindkey "\e\d" undo

bindkey "\e[3~" delete-char
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

#
# Environment Variables & Config
#

# General aliases
alias ls='ls --color'
alias ll='ls -al'
alias clear='echo -ne "\e[0;$[LINES]r"'

# Default Editor
export EDITOR='nano'

# Detect if this is an ssh session
SESSION_TYPE="local"
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE="ssh"
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE="ssh";;
  esac
fi
export SESSION_TYPE=$SESSION_TYPE

#
# dotdotdot updater
#
if [[ -x ~/.dotdotdot/update ]]; then
    ( ~/.dotdotdot/update )
fi

#
# zgen install
#
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then
    echo "Generating new zgen file."
    
    # specify plugins here
    zgen oh-my-zsh
    zgen load zsh-users/zsh-syntax-highlighting
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/command-not-found

    zgen load gauravmm/zsh-theme themes/gmm-zsh

    # generate the init script from plugins above
    zgen save
fi

# Add dotdotdot and scripts to PATH
export PATH=$PATH:~/.dotdotdot/bin:~/scripts

# Support SSH_AUTH_SOCK updating in tmux
if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock;

# if gem exists, include it in the path
if [[ -d ~/.gem/ruby/2.5.0/bin ]]; then
    export PATH=~/.gem/ruby/2.5.0/bin:$PATH
fi

# Gurobi
if [[ -d /opt/gurobi800 ]]; then
        export GUROBI_HOME=/opt/gurobi800/linux64
        export PATH=$GUROBI_HOME/bin/:$PATH
        export LD_LIBRARY_PATH=$GUROBI_HOME/lib:$LD_LIBRARY_PATH
fi

# Scripts directory
if [[ -d /data/scripts ]]; then
        export PATH=/data/scripts:$PATH
fi

#  PyEnv
if [[ -d $HOME/.pyenv ]]; then 
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi 
