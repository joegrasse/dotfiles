# .bashrc

# User specific aliases and functions

alias vi='vim'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias EXIT='exit'
alias sr='screen -DR'
alias cl='sudo cat /usr2/mysql/logs/mysql.err|grep -vE "(Statement may not be safe|Unsafe statement written to the binary log)"'

if test -n "$PS1"; then
	# Disable ctrl-S
	stty -ixon
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Check for 64bit
IS_64BIT=false
if [ `uname -m` == 'x86_64' ]; then
  IS_64BIT=true
fi

if [ -x /etc/profile.d/mysql.sh ] && [[ ! "$PATH" =~ 'mysql' ]]; then
        . /etc/profile.d/mysql.sh
fi

export PATH=$PATH:/sbin

if [ "$IS_64BIT" == true ]; then
  if [ -x '/usr2/shared/graj04/.local64/bin/vim' ]; then
    alias vim='/usr2/shared/graj04/.local64/bin/vim'
    export EDITOR=/usr2/shared/graj04/.local64/bin/vim
    
    if [ -d '/usr2/shared/graj04/.local64/bin' ]; then
        export PATH=/usr2/shared/graj04/.local64/bin:$PATH
    fi
  fi
else
  if [ -x '/usr2/shared/graj04/.local/bin/vim' ]; then
    alias vim='/usr2/shared/graj04/.local/bin/vim'
    export EDITOR=/usr2/shared/graj04/.local/bin/vim
    
    if [ -d '/usr2/shared/graj04/.local/bin' ]; then
        export PATH=/usr2/shared/graj04/.local/bin:$PATH
    fi
  fi
fi

# Go Stuff
if [ "$IS_64BIT" == true ]; then
	export GOROOT=$HOME/go-64
	export GOPATH=$HOME/gowork-64
else
	export GOROOT=$HOME/go
	export GOPATH=$HOME/gowork
fi

export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin

SCREEN_HOST=$HOSTNAME

setup_os_specific(){
	local os=`cat /etc/issue`
	case $os in
		*Red\ Hat*release\ 7* )
			setup_terminal "xterm-color"
		;;
		*CentOS*release\ 4* )
			setup_terminal "xterm-256color"
		;;
		*CentOS*release\ 5* )
			setup_terminal "xterm-256color"
		;;
		*CentOS*release\ 6* )
			setup_terminal "xterm-256color"
		;;
	esac
}

setup_terminal() {
   if [ -z "$1" ]; then
      newTerm="xterm-color"
   else
      newTerm=$1
   fi 

   if [ -t 0 ]; then
     tset $newterm
     export TERM="$newTerm"
   fi
}

function my_prompt {
        if [ "$PS1" ]; then
                local COLOR=""
                local NOCOLOR=""
                local TITLEBAR=""
                local SCREEN_COLOR=""
                
                local HOSTNAME=`hostname -f`

                local HOST=`echo $HOSTNAME|awk -F . '{print $1}'`
                local HOST_ENV=`echo $HOSTNAME|awk -F . '{print $2}'`

                if [ "$TERM" = "linux" ]; then
                        TITLEBAR=""
                else                        
                        if [ "$HOST_ENV" = "ts1" ]; then
                                COLOR="\\[$(tput bold)$(tput setab 2)$(tput setaf 7)\\]"
                                NOCOLOR="\\[$(tput sgr0)\\]"
                                SCREEN_COLOR="%{g}"
                        elif [ "$HOST_ENV" = "qa1" ]; then
                                COLOR="\\[$(tput bold)$(tput setab 4)$(tput setaf 7)\\]"
                                NOCOLOR="\\[$(tput sgr0)\\]"
                                SCREEN_COLOR="%{b}"
                        elif [ "$HOST_ENV" = "om2" ]; then
                                COLOR="\\[$(tput bold)$(tput setab 1)$(tput setaf 7)\\]"
                                NOCOLOR="\\[$(tput sgr0)\\]"
                                SCREEN_COLOR="%{r}"
                        else
                                HOST_ENV="UNKNOWN"
                                COLOR="\\[$(tput bold)$(tput rev)\\]"
                                NOCOLOR="\\[$(tput sgr0)\\]"
                                SCREEN_COLOR="%{w}"
                        fi
                        
                        TITLEBAR="\[\033]2;\u@$HOST.$HOST_ENV \W\007\]"
                fi
        
                local COMMAND_PROMPT="[\u@$HOST.$HOST_ENV \W]\$ "
                PS1=$TITLEBAR$COLOR$COMMAND_PROMPT$NOCOLOR
                SCREEN_HOST=$SCREEN_COLOR$HOST.$HOST_ENV
                export PS1
        fi
}

setup_os_specific
my_prompt
export SCREEN_HOST
umask 022
set -o emacs
