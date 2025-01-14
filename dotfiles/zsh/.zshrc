# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
  # zgen load MichaelAquilina/zsh-autoswitch-virtualenv

  #zgen load gauravmm/zsh-theme themes/gmm-zsh
  zgen load romkatv/powerlevel10k powerlevel10k

  # generate the init script from plugins above
  zgen save
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add dotdotdot and scripts to PATH
export PATH=$PATH:~/.dotdotdot/bin:~/scripts

# Support SSH_AUTH_SOCK updating in tmux
if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock.$HOST;
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock.$HOST;

# if gem exists, include it in the path
if [[ -d ~/.gem/ruby/2.6.0/bin ]]; then
  export PATH=~/.gem/ruby/2.6.0/bin:$PATH
fi
if [[ -d ~/gems ]]; then
  export GEM_HOME=~/gems
  export PATH=~/gems/bin:$PATH
fi

# Gurobi, prioritizing later versions:
if [[ -d /opt/gurobi951 ]]; then
  export GUROBI_HOME=/opt/gurobi951/linux64
elif [[ -d /opt/gurobi950 ]]; then
  export GUROBI_HOME=/opt/gurobi950/linux64
fi

if (( ${+GUROBI_HOME} )); then
  export PATH=$GUROBI_HOME/bin/:$PATH
  export LD_LIBRARY_PATH=$GUROBI_HOME/lib:$LD_LIBRARY_PATH
fi

if [[ -d "${HOME}/.mujoco/mujoco210/bin" ]]; then
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.mujoco/mujoco210/bin"
fi

if [[ -d "/usr/lib/nvidia" ]]; then
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/nvidia"
fi

if [[ -d "${HOME}/.local/bin" ]]; then
  export PATH="$PATH:$HOME/.local/bin"
fi

# Scripts directory
if [[ -d /data/scripts ]]; then
  export PATH=/data/scripts:$PATH
fi

# PyEnv
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  # Adopt new behaviour to disable the annoying notice:
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

# TeXLive
if [[ -d "/usr/local/texlive/2023/bin/x86_64-linux" ]]; then
  export PATH="$PATH:/usr/local/texlive/2023/bin/x86_64-linux"
fi

# Google Cloud SDK.
GOOGLE_CLOUD_SDK_PATH="$HOME/google-cloud-sdk/";
if [ -d "$GOOGLE_CLOUD_SDK_PATH" ]; then
  export PATH="$PATH:$GOOGLE_CLOUD_SDK_PATH/bin";
  . "$GOOGLE_CLOUD_SDK_PATH/path.zsh.inc";
  . "$GOOGLE_CLOUD_SDK_PATH/completion.zsh.inc";
fi

# Local Scripts
if [[ -d "/home/gauravmm/.local/bin" ]]; then
  export PATH="$PATH:/home/gauravmm/.local/bin"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

zstyle ':completion:*:ssh:*' hosts off

# Set LS_COLORS to brighten bold colors, for compatiblity with Kitty

export LS_COLORS='rs=0:di=01;94:ln=01;96:mh=00:pi=40;33:so=01;95:do=01;95:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;92:*.tar=01;91:*.tgz=01;91:*.arc=01;91:*.arj=01;91:*.taz=01;91:*.lha=01;91:*.lz4=01;91:*.lzh=01;91:*.lzma=01;91:*.tlz=01;91:*.txz=01;91:*.tzo=01;91:*.t7z=01;91:*.zip=01;91:*.z=01;91:*.dz=01;91:*.gz=01;91:*.lrz=01;91:*.lz=01;91:*.lzo=01;91:*.xz=01;91:*.zst=01;91:*.tzst=01;91:*.bz2=01;91:*.bz=01;91:*.tbz=01;91:*.tbz2=01;91:*.tz=01;91:*.deb=01;91:*.rpm=01;91:*.jar=01;91:*.war=01;91:*.ear=01;91:*.sar=01;91:*.rar=01;91:*.alz=01;91:*.ace=01;91:*.zoo=01;91:*.cpio=01;91:*.7z=01;91:*.rz=01;91:*.cab=01;91:*.wim=01;91:*.swm=01;91:*.dwm=01;91:*.esd=01;91:*.jpg=01;95:*.jpeg=01;95:*.mjpg=01;95:*.mjpeg=01;95:*.gif=01;95:*.bmp=01;95:*.pbm=01;95:*.pgm=01;95:*.ppm=01;95:*.tga=01;95:*.xbm=01;95:*.xpm=01;95:*.tif=01;95:*.tiff=01;95:*.png=01;95:*.svg=01;95:*.svgz=01;95:*.mng=01;95:*.pcx=01;95:*.mov=01;95:*.mpg=01;95:*.mpeg=01;95:*.m2v=01;95:*.mkv=01;95:*.webm=01;95:*.ogm=01;95:*.mp4=01;95:*.m4v=01;95:*.mp4v=01;95:*.vob=01;95:*.qt=01;95:*.nuv=01;95:*.wmv=01;95:*.asf=01;95:*.rm=01;95:*.rmvb=01;95:*.flc=01;95:*.avi=01;95:*.fli=01;95:*.flv=01;95:*.gl=01;95:*.dl=01;95:*.xcf=01;95:*.xwd=01;95:*.yuv=01;95:*.cgm=01;95:*.emf=01;95:*.ogv=01;95:*.ogx=01;95:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';

# Gradle support
if [[ -d "$HOME/software/gradle-7.4.2/bin" ]]; then
  export PATH="$PATH:$HOME/software/gradle-7.4.2/bin"
fi

# Some snap error:
if [[ -d "/snap/bin" ]]; then
  export PATH="/snap/bin:${PATH}"
fi

if [[ -f "$HOME/.rvm/scripts/rvm" ]]; then
  export PATH="$PATH:$HOME/.rvm/bin"
  source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

if [[ -f "$HOME/.rbenv" ]]; then
  eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"
fi

#
# Remote machines.
#

if [[ "$(hostname)" == "Gewisse" ]]; then
  eval `ssh-agent` > /dev/null
  ssh-add 2> /dev/null
fi
