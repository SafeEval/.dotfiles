# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add exiftool shortcut.
if [ -x /usr/bin/dircolors ]; then
    alias exifstrip='exiftool -all= '
fi



# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


#############################
# Alias definitions.
#############################

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ `which htmlhint-ng2` ]; then
  alias htmlhint='htmlhint-ng2'
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


####################
# Mouse sensitivity
####################

xset m 1/2 4

############
# Keymapping
############

# Remap caps lock to ctrl
# To restore capslock functionality.
function caps2ctrl {
  if [ -x /usr/bin/setxkbmap ]; then
      setxkbmap -option ctrl:nocaps;
  fi;
}
caps2ctrl;
alias resetcapslock='setxkbmap -option;'
alias RESETCAPSLOCK='setxkbmap -option;'


############
# Import paths
############

#if [ -z $LD_LIBRARY_PATH ]; then
#  export LD_LIBRARY_PATH="/snap/core/6130/lib/x86_64-linux-gnu/"
#else
#  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/snap/core/6130/lib/x86_64-linux-gnu/"
#fi



######
# Bash
######

# The "**" pattern for paths will match directory depth of 0 or more.
shopt -s globstar


# So as not to be disturbed by Ctrl-S ctrl-Q in terminals:
stty -ixon

# Color pattern, with full output.
function bcolor {
  grep --color "$1\|"
}

# https://sanctum.geek.nz/arabesque/better-bash-history/

# Append history, instead of rewriting it.
shopt -s histappend

# Roll up multi-line commands into a single line.
shopt -s cmdhist

# Store history immediately, instead of at end of session.
export PROMPT_COMMAND='history -a'

# Large history file size.
export HISTFILESIZE=1000000
export HISTSIZE=1000000

# Ignore commands starting with a space, and duplicates.
export HISTCONTROL=ignoreboth

# Timestamp commands in history.
# export HISTTIMEFORMAT='%F %T '


###########
# Sandboxes
###########

# Firefox resource restriction with cgexec
# sudo cgcreate -a $USER:$USER -t $USER:$USER -g memory,cpu:browsers
# echo 512 | sudo tee -a /sys/fs/cgroup/cpu/browsers/cpu.shares
# echo $((4000 * 1024 * 1024)) | sudo tee -a sys/fs/cgroup/memory/browsers/memory.limit_in_bytes
# echo 0 | sudo tee -a /sys/fs/cgroup/memory/browsers/memory.swappiness
alias ffsandbox="cgexec -g cpu,memory:browsers /usr/bin/firefox"

# VMWare resource restriction with cgexec
# sudo cgcreate -a $USER:$USER -t $USER:$USER -g memory,cpu:hypervisors
# echo 512 | sudo tee -a /sys/fs/cgroup/cpu/hypervisors/cpu.shares
# echo $((13000 * 1024 * 1024)) | sudo tee -a sys/fs/cgroup/memory/hypervisors/memory.limit_in_bytes
# echo 0 | sudo tee -a /sys/fs/cgroup/memory/hypervisors/memory.swappiness
alias ffvmware="cgexec -g cpu,memory:browsers /usr/lib/vmware/bin/vmware"


#####
# SSH
#####

alias agentkey='eval `/usr/bin/ssh-agent -s`; ssh-add -t 1h;'



#####
# vim
#####

export EDITOR="/usr/bin/vim"
# FZF plugin external binaries.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Universal CTags plugin external binaries.
export PATH="$HOME/.ctags:$PATH"


########
# Heroku
########

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


#####
# git
#####

alias git-lineage='git log --all --graph --decorate --oneline --simplify-by-decoration'


########
# Python
########

# Python virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/workspace
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
# VENVWRAP="/usr/share/virtualenvwrapper/virtualenvwrapper.sh"
# if [ -f $VENVWRAP ]; then
#   source $VENVWRAP;
# fi

# Add local python directories
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"


############
# JavaScript
############

# Set nvm root directory.
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Local npm modules can be found.
export PATH="$PATH:./node_modules/.bin"


############
# Go
############

export GOPATH=~/go
export PATH="$PATH:$GOPATH/bin"
if [ ! -d $GOPATH ]; then
  mkdir -p $GOPATH/{bin,src};
fi


######
# Ruby
######

export GEM_HOME=$HOME/.gem
export GEM_PATH=$GEM_HOME
export PATH="$GEM_PATH/bin:$PATH"

# Ruby version manager.
# May need to fix paths in `.profile` to fix warnings.
export PATH="/usr/share/rvm/bin:$PATH"




###################
# Kubernetes
###################

source <(kubectl completion bash)

# Istio
export PATH="$PATH:$HOME/bin/istioctl"
