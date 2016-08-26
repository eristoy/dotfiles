#!/bin/bash
iatest=$(expr index "$-" i)
case $- in
    *i*) ;;
      *) return;;
esac
#######################################################
# SOURCED ALIAS'S AND SCRIPTS
#######################################################

# Source global definitions
if [ -f /etc/bashrc ]; then
         . /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
fi

#######################################################
# EXPORTS
#######################################################

# Disable the bell
if [[ $iatest > 0 ]]; then bind "set bell-style none"; fi

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Allow ctrl-S for history navigation (with ctrl-R)
stty -ixon

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# Set the default editor
export EDITOR=vim
export VISUAL=vim
#alias pico='edit'
#alias spico='sedit'
#alias nano='edit'
#alias snano='sedit'

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
        source ~/.bash_aliases
fi

#######################################################
# SPECIAL FUNCTIONS
#######################################################


grab() {
            sudo chown -R ${USER} ${1:-.}
        }

livehosts() {
    nmap -b -sn $1 -oG - | awk '/Up$/{print $2}'
}

# Use the best version of pico installed


edit ()
{
                vim "$@"
}
sedit ()
{
                sudo vim "$@"
}

# Extracts any archive(s) (if unp isn't installed)
extract () {
        for archive in $*; do
                if [ -f $archive ] ; then
                        case $archive in
                                *.tar.bz2)   tar xvjf $archive    ;;
                                *.tar.gz)    tar xvzf $archive    ;;
                                *.bz2)       bunzip2 $archive     ;;
                                *.rar)       rar x $archive       ;;
                                *.gz)        gunzip $archive      ;;
                                *.tar)       tar xvf $archive     ;;
                                *.tbz2)      tar xvjf $archive    ;;
                                *.tgz)       tar xvzf $archive    ;;
                                *.zip)       unzip $archive       ;;
                                *.Z)         uncompress $archive  ;;
                                *.7z)        7z x $archive        ;;
                                *)           echo "don't know how to extract '$archive'..." ;;
                        esac
                else
                        echo "'$archive' is not a valid file!"
                fi
        done
}

# Searches for text in all files in the current folder
ftext ()
{
        # -i case-insensitive
        # -I ignore binary files
        # -H causes filename to be printed
        # -r recursive search
        # -n causes line number to be printed
        # optional: -F treat search term as a literal, not a regular expression
        # optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
        grep -iIHrn --color=always "$1" . | less -r
}

# Show current network information
netinfo ()
{
        echo "--------------- Network Information ---------------"
        /sbin/ifconfig | awk /'inet addr/ {print $2}'
        echo ""
        /sbin/ifconfig | awk /'Bcast/ {print $3}'
        echo ""
        /sbin/ifconfig | awk /'inet addr/ {print $4}'

        /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
        echo "---------------------------------------------------"
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip ()
{
        # Dumps a list of all IP addresses for every device
        # /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';

        # Internal IP Lookup
        echo -n "Internal IP: " ; /sbin/ifconfig | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

        # External IP Lookup
        echo -n "External IP: " ; wget http://smart-ip.net/myip -O - -q
}


# For some reason, rot13 pops up everywhere
rot13 () {
        if [ $# -eq 0 ]; then
                tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
        else
                echo $* | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
        fi
}

# Trim leading and trailing spaces (for scripts)
trim()
{
        local var=$@
        var="${var#"${var%%[![:space:]]*}"}"  # remove leading whitespace characters
        var="${var%"${var##*[![:space:]]}"}"  # remove trailing whitespace characters
        echo -n "$var"
}
add-alias ()
{
    local name=$1 value="$2"
    echo alias $name=\'$value\' >>~/.bash_aliases
    eval alias $name=\'$value\'
    alias $name
}

#######################################################
# Set the ultimate amazing command prompt
#######################################################

alias cpu="grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)*100/(\$2+\$4+\$5)} END {print usage}' | awk '{printf(\"%.1f\n\", \$1)}'"
function __setprompt
{
        local LAST_COMMAND=$? # Must come first!

        # Define colors
        local LIGHTGRAY="\033[0;37m"
        local WHITE="\033[1;37m"
        local BLACK="\033[0;30m"
        local DARKGRAY="\033[1;30m"
        local RED="\033[0;31m"
        local LIGHTRED="\033[1;31m"
        local GREEN="\033[0;32m"
        local LIGHTGREEN="\033[1;32m"
        local BROWN="\033[0;33m"
        local YELLOW="\033[1;33m"
        local BLUE="\033[0;34m"
        local LIGHTBLUE="\033[1;34m"
        local MAGENTA="\033[0;35m"
        local LIGHTMAGENTA="\033[1;35m"
        local CYAN="\033[0;36m"
        local LIGHTCYAN="\033[1;36m"
        local NOCOLOR="\033[0m"
        # Bold
        local BBlack='\e[1;30m'       # Black
        local BRed='\e[1;31m'         # Red
        local BGreen='\e[1;32m'       # Green
        local BYellow='\e[1;33m'      # Yellow
        local BBlue='\e[1;34m'        # Blue
        local BPurple='\e[1;35m'      # Purple
        local BCyan='\e[1;36m'        # Cyan
        local BWhite='\e[1;37m'       # White
        # Background
        local On_Black='\e[40m'       # Black
        local On_Red='\e[41m'         # Red
        local On_Green='\e[42m'       # Green
        local On_Yellow='\e[43m'      # Yellow
        local On_Blue='\e[44m'        # Blue
        local On_Purple='\e[45m'      # Purple
        local On_Cyan='\e[46m'        # Cyan
        local On_White='\e[47m'       # White
        # High Intensity
        local IBlack='\e[0;90m'       # Black
        local IRed='\e[0;91m'         # Red
        local IGreen='\e[0;92m'       # Green
        local IYellow='\e[0;93m'      # Yellow
        local IBlue='\e[0;94m'        # Blue
        local IPurple='\e[0;95m'      # Purple
        local ICyan='\e[0;96m'        # Cyan
        local IWhite='\e[0;97m'       # White

        # Show error exit code if there is one
        if [[ $LAST_COMMAND != 0 ]]; then
                # PS1="\[${RED}\](\[${LIGHTRED}\]ERROR\[${RED}\])-(\[${LIGHTRED}\]Exit Code \[${WHITE}\]${LAST_COMMAND}\[${RED}\])-(\[${LIGHTRED}\]"
                PS1="\[${DARKGRAY}\](\[${LIGHTRED}\]ERROR\[${DARKGRAY}\])-(\[${RED}\]Exit Code \[${LIGHTRED}\]${LAST_COMMAND}\[${DARKGRAY}\])-(\[${RED}\]"
                if [[ $LAST_COMMAND == 1 ]]; then
                        PS1+="General error"
                elif [ $LAST_COMMAND == 2 ]; then
                        PS1+="Missing keyword, command, or permission problem"
                elif [ $LAST_COMMAND == 126 ]; then
                        PS1+="Permission problem or command is not an executable"
                elif [ $LAST_COMMAND == 127 ]; then
                        PS1+="Command not found"
                elif [ $LAST_COMMAND == 128 ]; then
                        PS1+="Invalid argument to exit"
                elif [ $LAST_COMMAND == 129 ]; then
                        PS1+="Fatal error signal 1"
                elif [ $LAST_COMMAND == 130 ]; then
                        PS1+="Script terminated by Control-C"
                elif [ $LAST_COMMAND == 131 ]; then
                        PS1+="Fatal error signal 3"
                elif [ $LAST_COMMAND == 132 ]; then
                        PS1+="Fatal error signal 4"
                elif [ $LAST_COMMAND == 133 ]; then
                        PS1+="Fatal error signal 5"
                elif [ $LAST_COMMAND == 134 ]; then
                        PS1+="Fatal error signal 6"
                elif [ $LAST_COMMAND == 135 ]; then
                        PS1+="Fatal error signal 7"
                elif [ $LAST_COMMAND == 136 ]; then
                        PS1+="Fatal error signal 8"
                elif [ $LAST_COMMAND == 137 ]; then
                        PS1+="Fatal error signal 9"
                elif [ $LAST_COMMAND -gt 255 ]; then
                        PS1+="Exit status out of range"
                else
                        PS1+="Unknown error code"
                fi
                PS1+="\[${DARKGRAY}\])\[${NOCOLOR}\]\n"
        else
                PS1=""
        fi

        # Date
                PS1+="(\[${DARKGRAY}\]\[${CYAN}\]\$(date +%a) $(date +%b-'%-d')" # Date
        PS1+="${CYAN} $(date +'%-I':%M:%S%P)\[${DARKGRAY}\])-" # Time

        # CPU
        PS1+="(\[${MAGENTA}\]CPU $(cpu)%"

        # Jobs
        PS1+="\[${DARKGRAY}\]:\[${MAGENTA}\]Jobs \j"

        # Network Connections (for a server - comment out for non-server)
        PS1+="\[${DARKGRAY}\]:\[${MAGENTA}\]Net $(awk 'END {print NR}' /proc/net/tcp)"

        PS1+="\[${DARKGRAY}\])-"
        # Total size of files in current dir
#        PS1+="(\[${GREEN}\]Total Size $(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')\[${DARKGRAY}\]:"
        # Number of files
 #       PS1+="\[${GREEN}\]Total Files \$(/bin/ls -A -1 | /usr/bin/wc -l)\[${DARKGRAY}\])\n"
        # what term?
        #PS1+="\[${IWhite}\]${SSH_TTY}\n"
        # User and server
        local SSH_IP=`echo $SSH_CONNECTION | awk '{ print $1 }'`
        if [ $SSH_IP ] ; then
                PS1+="(\[${LIGHTBLUE}\]ssh:${SSH_IP}\[${DARKGRAY}\])-(\[${IGreen}\]\u\[${RED}\]@${BROWN}\h"
        else
                PS1+="(\[${IGreen}\]\u\[${RED}\]@\[${BROWN}\]\h"
        fi

        # Current directory
        PS1+="\[${DARKGRAY}\]:\[${BROWN}\]\w\[${DARKGRAY}\])"

        # Skip to the next line
        PS1+="\n"

        if [[ $EUID -ne 0 ]]; then
                PS1+="\[${GREEN}\]>\[${NOCOLOR}\] " # Normal user
        else
                PS1+="\[${On_Red}\]#>\[${NOCOLOR}\] " # Root user
        fi

        # PS2 is used to continue a command using the \ character
        PS2="\[${DARKGRAY}\]>\[${NOCOLOR}\] "

        # PS3 is used to enter a number choice in a script
        PS3='Please enter a number from above list: '

        # PS4 is used for tracing a script in debug mode
        PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
        case ${TERM} in
	       xterm*|rxvt*|Eterm|aterm|kterm|gnome*|terminator*)
                PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
                ;;
        screen)
                PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
                ;;
esac
}
PROMPT_COMMAND='__setprompt'
read -p "Do you want to run tmux? (Y/N) " -n -r
echo
if [[ !$REPLY =~ ^[Yy]$ ]]
then
    if command -v tmux>/dev/null;
    then
        [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
    fi
fi
