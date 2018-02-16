#!/bin/bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -A --group-directories-first'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
    alias reboot='sudo reboot'
    alias update='sudo apt-fast upgrade'
fi

# some more ls aliases
alias ll="ls -l"
alias ll.='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias dir="ls -lF --color"
alias dirs="ls -lFS --color"

## Show hidden files ##
alias l.='ls -d .* --color=auto --group-directories-first'


## a quick way to get out of current directory ##
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# Make mount command output pretty and human readable format
alias mount='mount |column -t'

# handy short cuts #
alias h='history'
alias j='jobs -l'
 
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'


# Show open ports
alias ports='netstat -tulanp'

# Resume wget by default
alias wget='wget -c'

alias top='atop'


alias df='df -H'
alias du='du -ch'
alias du1='du -d 1'
alias du20='du -d1  -BM * | sort -n -r | head -20'
#alias usage=’du -ch 2> /dev/null |tail -1′

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


alias restartpc='sudo shutdown -r 0 RESTARTING PC'
alias Install='sudo apt-fast install '
alias Uninstall='sudo apt-fast remove '
alias Purge='sudo apt-fast purge '
alias Upgrade='sudo apt-get -f install; sudo apt-fast -y update ; sudo apt-get -y -qq upgrade ; sudo apt-get -y -qq  dist-upgrade ; sudo apt-fast -y autoclean ; sudo apt autoremove -y'

alias mkdir="mkdir -p"
alias myip="curl http://ipecho.net/plain; echo"

alias h=history

#-------------------------------------------------------------
# Process related
#-------------------------------------------------------------

# psg bash
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Get system memory, cpu usage, and gpu memory info quickly
## pass options to free ## 
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
## get GPU ram on desktop / laptop## 
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

######################  scripting
# make executable
alias ax="chmod a+x"

# trim newlines
alias tn='tr -d "\n"'

# uzips zip files in directoris with the same name as the archive
#alias dirzip=for f in *.zip; do unzip -d "${f%*.zip}" "$f"; done
