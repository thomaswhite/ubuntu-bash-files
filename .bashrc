# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

for f in ~/.bash_functions* ; do source $f; done
if [ -f ~/.bash_aliases ];      then . ~/.bash_aliases;     fi
if [ -f ~/.bash_colours ];      then . ~/.bash_colours;     fi
if [ -f ~/.bash_local ];        then . ~/.bash_local;       fi
if [ -f ~/.bash_daily_backup ]; then . ~/.bash_daily_backup; fi

#### same section copied from http://tldp.org/LDP/abs/html/sample-bashrc.html
#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------

if [ -f /etc/bashrc ]; then . /etc/bashrc; fi

##################################################
# PATH						 #
##################################################

if [ "$UID" -eq 0 ]; then
    PATH=$PATH:$HOME/bin:$HOME/.local/bin:/usr/local:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
fi

# https://unix.stackexchange.com/questions/40749/remove-duplicate-path-entries-with-awk-command
PATH=$(printf %s "$PATH" | awk -vRS=: '!a[$0]++' | paste -s -d:)


### ------------------------------------------------------------------------

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#    PS1='\[\033[01;34m\]\w \n\t \[\033[00m\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[1;33m\] $ \[\033[0m\]'
    PS1='\n\[\033[01;34m\]\w\[\e[m\]\n\A \[\e[01;32m\]\u\[\033[01;33m\]@\[\e[01;32m\]\h\[\e[m\] \\$ \[\033[0m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt


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


#-------------------------------------------------------------

#export NVM_DIR="/home/thomas/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm



export HH_CONFIG=hicolor         # get more colors
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh \C-j"'; fi

# navigate back in the history filtering only the lines that match with what has been typed so far
bind '"\e[A":history-search-backward'

#-------------------------------------------------------------
# HISTORY section 
#-------------------------------------------------------------

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options ignorespace | ignoredups | ignoreboth
HISTCONTROL=ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500000
HISTFILESIZE=5000000
#export HISTTIMEFORMAT="%F %T "
#export HISTTIMEFORMAT="%d/%m/%y %T "

#Don't save ls, ps and history commands
export HISTIGNORE="ll:ls:ps:cd ~:cd ..:h:alias" 

mkdir -p /tmp/apt-fast

# https://stackoverflow.com/questions/30023780/sorting-directory-contents-including-hidden-files-by-name-in-the-shell
export LC_ALL=C 

source "$HOME"/merge_history.bash

