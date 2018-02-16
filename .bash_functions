#!/bin/bash

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f "$1" ] ; then
        NAME=${1%.*}
        #mkdir $NAME && cd $NAME
        case "$1" in
          *.tar.bz2)   tar xvjf ./"$1"    ;;
          *.tar.gz)    tar xvzf ./"$1"    ;;
          *.tar.xz)    tar xvJf ./"$1"    ;;
          *.lzma)      unlzma ./"$1"      ;;
          *.bz2)       bunzip2 ./"$1"     ;;
          *.rar)       unrar x -ad ./"$1" ;;
          *.gz)        gunzip ./"$1"      ;;
          *.tar)       tar xvf ./"$1"     ;;
          *.tbz2)      tar xvjf ./"$1"    ;;
          *.tgz)       tar xvzf ./"$1"    ;;
          *.zip)       unzip ./"$1"       ;;
          *.Z)         uncompress ./"$1"  ;;
          *.7z)        7z x ./"$1"        ;;
          *.xz)        unxz ./"$1"        ;;
          *.exe)       cabextract ./"$1"  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "'$1' - file does not exist"
    fi
fi
}


#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------


function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }



function killps()   # kill by process name
{
    local pid pname sig="-TERM"   # default signal
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} )
    do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}

function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
    for fs ; do

        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi

        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out=${info[2]}" "$out"] ("$free" free on "$fs")"
        echo -e $out
    done
}

#-------------------------------------------------------------

function my_ip() # Get IP adress on ethernet.
{
    MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${MY_IP:-"Not connected"}
}

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${BRed}$HOST"
    echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    echo -e "\n${BRed}Machine stats :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free
    echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
    echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
    echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo
}

#-------------------------------------------------------------

mcd () {
    mkdir -p $1
    cd $1
}

function run_in_terminal {
  xfce4-terminal --geometry 120x35  -H --hide-menubar --title="$1" --command "$2"
}

## http://brettterpstra.com/2013/07/24/bash-image-tools-for-web-designers/

# Quickly get image dimensions from the command line
function imgsize() {
	local width height
	if [[ -f $1 ]]; then
		height=$(sips -g pixelHeight "$1"|tail -n 1|awk '{print $2}')
		width=$(sips -g pixelWidth "$1"|tail -n 1|awk '{print $2}')
		echo "${width} x ${height}"
	else
		echo "File not found"
	fi
}
# encode a given image file as base64 and output css background property to clipboard
function 64enc() {
	openssl base64 -in $1 | awk -v ext="${1#*.}" '{ str1=str1 $0 }END{ print "background:url(data:image/"ext";base64,"str1");" }'|pbcopy
	echo "$1 encoded to clipboard"
}

function 64font() {
	openssl base64 -in $1 | awk -v ext="${1#*.}" '{ str1=str1 $0 }END{ print "src:url(\"data:font/"ext";base64,"str1"\")  format(\"woff\");" }'|pbcopy
	echo "$1 encoded as font and copied to clipboard"
}


## ---------------------------
## Print a horizontal rule
rule () {
	printf -v _hr "%*s" $(tput cols) && echo ${_hr// /${1--}}
}

## Print a horizontal rule with a message
rulem ()  {
	if [ $# -eq 0 ]; then
		echo "Usage: rulem MESSAGE [RULE_CHARACTER]"
		return 1
	fi
	# Fill line with ruler character ($2, default "-"), reset cursor, move 2 cols right, print message
	printf -v _hr "%*s" $(tput cols) && echo -en ${_hr// /${2--}} && echo -e "\r\033[2C$1"
}

## http://brettterpstra.com/2015/01/05/sizeup-tidy-filesize-information-in-terminal/
__sizeup_build_query () {
	local bool="and"
	local query=""
	for t in $@; do
		query="$query -$bool -iname \"*.$t\""
		bool="or"
	done
	echo -n "$query"
}

__sizeup_humanize () {
	local size=$1
	if [ $size -ge 1073741824 ]; then
		printf '%6.2f%s' $(echo "scale=2;$size/1073741824"| bc) G
	elif [ $size -ge 1048576 ]; then
		printf '%6.2f%s' $(echo "scale=2;$size/1048576"| bc) M
	elif [ $size -ge 1024 ]; then
		printf '%6.2f%s' $(echo "scale=2;$size/1024"| bc) K
	else
		printf '%6.2f%s' ${size} b
	fi
}

sizeup () {
	local helpstring="Show file sizes for all files with totals\n-r\treverse sort\n-[0-3]\tlimit depth (default 4 levels, 0=unlimited)\nAdditional arguments limit by file extension\n\nUsage: sizeup [-r[0123]] ext [,ext]"
	local totalb=0
	local size output reverse OPT
	local depth="-maxdepth 4"
	OPTIND=1
	while getopts "hr0123" opt; do
		case $opt in
			r) reverse="-r " ;;
			0) depth="" ;;
			1) depth="-maxdepth 1" ;;
			2) depth="-maxdepth 2" ;;
			3) depth="-maxdepth 3" ;;
			h) echo -e $helpstring; return;;
			\?) echo "Invalid option: -$OPTARG" >&2; return 1;;
		esac
	done
	shift $((OPTIND-1))

	local cmd="find . -type f ${depth}$(__sizeup_build_query $@)"
	local counter=0
	while read -r file; do
		counter=$(( $counter+1 ))
		size=$(stat -f '%z' "$file")
		totalb=$(( $totalb+$size ))
		>&2 echo -ne $'\E[K\e[1;32m'"${counter}:"$'\e[1;31m'" $file "$'\e[0m'"("$'\e[1;31m'$size$'\e[0m'")"$'\r'
		# >&2 echo -n "$(__sizeup_humanize $totalb): $file ($size)"
		# >&2 echo -n $'\r'
		output="${output}${file#*/}*$size*$(__sizeup_humanize $size)\n"
	done < <(eval $cmd)
	>&2 echo -ne $'\r\E[K\e[0m'
	echo -e "$output"| sort -t '*' ${reverse}-nk 2 | cut -d '*' -f 1,3 | column -s '*' -t
	echo $'\e[1;33;40m'"Total: "$'\e[1;32;40m'"$(__sizeup_humanize $totalb)"$'\e[1;33;40m'" in $counter files"$'\e[0m'
}

## http://brettterpstra.com/2016/04/27/shell-tricks-shorten-every-line-of-output/
# Truncate each line of the input to X characters
# flag -s STRING (optional): add STRING when truncated
# switch -l (optional): truncate from left instead of right
# param 1: (optional, default 70) length to truncate to
shorten () {
	local helpstring="Truncate each line of the input to X characters\n\t-l              Shorten from left side\n\t-s STRING         replace truncated characters with STRING\n\n\t$ ls | shorten -s ... 15"
	local ellip="" left=false
	OPTIND=1
	while getopts "hls:" opt; do
		case $opt in
			l) left=true ;;
			s) ellip=$OPTARG ;;
			h) echo -e $helpstring; return;;
			*) return 1;;
		esac
	done
	shift $((OPTIND-1))

	if $left; then
		cat | sed -E "s/.*(.{${1-70}})$/${ellip}\1/"
	else
		cat | sed -E "s/(.{${1-70}}).*$/\1${ellip}/"
	fi
}

## http://brettterpstra.com/2016/04/26/shell-tricks-list-files-with-most-text-matches/
# Find files in the current directory containing the most occurrences of a pattern
# switch -c: turn on display of occurrence counts
# switch -r: reverse sort order (default ascending)
# flag -m COUNT: minimum number of occurrences required to include file in results
# param 1: (required) search pattern (regex allowed, case insensitive)
#
# Results are output in ascending order by occurrence count
matches () {

	local counts=false minmatches=1 patt width=1 reverse=""
	local helpstring="Find files in the current directory containing the most occurrences of a pattern\n\t-c         Include occurrence counts in output\n\t-r         Reverse sort order (default ascending)\n\t-m COUNT   Minimum number of matches required\n\t-h         Display this help screen\n\n	Example:\n\t# search for files containing at least 3 occurrences\n\t# of the word \"jekyll\", display filenames with counts\n\n\t$ matches -c -m 3 jekyll"

	OPTIND=1
	while getopts "crm:h" opt; do
		case $opt in
			c) counts=true ;;
			r) reverse="r" ;;
			m) minmatches=$OPTARG ;;
			h) echo -e $helpstring; return;;
			*) return 1;;
		esac
	done
	shift $((OPTIND-1))

	if [ $# -ne 1 ]; then
		echo -e $helpstring
		return 1
	fi

	patt=$1; shift

	OLDIFS=$IFS
	IFS=$'\n'

	declare -a matches=$(while read -r line; do \
	                grep -Hi -c -E "$patt" "$line"; \
	              done < <(grep -lIi -E "$patt" * 2> /dev/null) \
	              | sort -t: -${reverse}n -k 2)
	width=$(echo -n ${matches[0]##*:}|wc -c|tr -d ' ')

	for mtch in ${matches[@]}; do
		if [ ${mtch##*:} -ge $minmatches ]; then
			if $counts; then
				printf "%${width}d: %s\n" ${mtch##*:} "${mtch%:*}"
			else
				echo "${mtch%:*}"
			fi
		fi
	done

	IFS=$OLDIFS
}

## http://brettterpstra.com/2015/11/24/shell-tricks-quick-line-numbering/
# output a text file with line numbers
lno() {
    if [ $# == 0 ]; then
        echo "No filename provided."
    else
        sed = "$1" | paste -s -d '\t\n' - -
    fi
}

