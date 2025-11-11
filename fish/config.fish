# Get the time elapsed since a program started
# Searches all running processes for the name provided in $1
function elapsed
    set proc $argv[1]
    ps -eo pid,cmd,stime,etime | \grep -iE "$proc|PID" | \grep -vE '(grep|ps)'
end

# Sync local files with server files
function fsa
    # Requires server and client to be setup with unison (https://github.com/bcpierce00/unison)
    # `server` hostname is from ssh config
    unison -auto -batch ~/sync ssh://server/sync
end

# Sync local files with server files
# See `fsa` above
function fs
    unison -auto ~/sync ssh://server/sync
end

export EDITOR=nvim
export MANPAGER='nvim +Man!'
export PAGER='nvim -R'

if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ll="eza -lhaF --icons --git"
    #alias cd="/usr/bin/cd -P" # I like cd to resolve links
    alias cp="cp -v" # Give me verbosity
    alias rm="rm -v" # Give me verbosity
    alias mv="mv -v" # Give me verbosity
    alias mkdir="mkdir -pv" # Create parent folders and give me verbosity
    alias python="python3"
    alias tree="eza -ThaF --icons --git -I 'target|node_modules|venv|.git'"
    alias :q="exit" # I can't help the vi
    alias serve="basic-http-server" # https://github.com/brson/basic-http-server
    alias feh='feh -B "#222" --force-aliasing --keep-zoom-vp -z'

    alias ga='git add'
    alias gaa='git add -A'
    alias gc='git commit'
    alias gcm='git commit -m'
    alias gd='git diff'
    alias gl='git log'
    alias gp='git pull'
    alias gpsh='git push'
    alias gss='git status -s'

    abbr npm pnpm
    abbr npx pnpx

    bind alt-backspace backward-kill-word
    bind alt-l downcase-word

    fzf --fish | source
end

function format_duration \
    --description="Format milliseconds to a human readable format" \
    --argument-names \
        milliseconds

    test "$milliseconds" -lt 0; and return $FAILURE

    set --local time
    set --local days (math --scale=0 "$milliseconds / 86400000")
    test "$days" -gt 0; and set --append time (printf "%sd" $days)
    set --local hours (math --scale=0 "$milliseconds / 3600000 % 24")
    test "$hours" -gt 0; and set --append time (printf "%sh" $hours)
    set --local minutes (math --scale=0 "$milliseconds / 60000 % 60")
    test "$minutes" -gt 0; and set --append time (printf "%sm" $minutes)
    set --local seconds (math --scale=0 "$milliseconds / 1000 % 60")

    set --append time (printf "%ss" $seconds)

    echo -e (string join ' ' $time)
end

function prompt_pwd2
    echo -n (string replace "$HOME" '~' $PWD)
end

function fish_title
    echo (whoami)@(hostname): (prompt_pwd2)
end

function nvim
    command nvim $argv 2>/dev/null
end

function fish_prompt
    set --local duration $CMD_DURATION
    set --local exit_status $status

	set_color brblack
	echo -n "["(date "+%H:%M")"] "
    # set_color blue
    # echo -n (command -q hostname; and hostname; or hostnamectl hostname)
    set_color brblack
    # echo -n ':'
    set_color blue
    prompt_pwd2
	set_color brblack
	printf '%s ' (__fish_git_prompt | sed 's/^ (/ /' | sed 's/)$//')

    # Show the time that the previous command took
    if [ $duration -gt '3000' ]
        set_color yellow
        printf '%s ' (format_duration $duration false)
    end

    # Error shown by prompt char
    if [ $exit_status != 0 ]
        set_color red
    else 
        set_color purple
    end

	echo -n '❯ '
	set_color normal
end

function fish_greeting
end
# function fish_greeting
#     echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
# 	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
# 	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
# 	echo -e ' \e[1mDisk usage:\e[0m'
# 	echo -ne (\
# 		df -l -h | grep -E 'dev/(xvda|sd|mapper|nvme)' | \
# 		awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
# 		sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
# 		paste -sd ''\
# 	)
# 
# 	set_color normal
# end
