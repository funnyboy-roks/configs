fish_add_path ~/scripts
fish_add_path ~/.cargo/bin
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
    echo (whoami)@(uname -n): (prompt_pwd2)
end

function nvim
    command nvim $argv 2>/dev/null
end

function fish_prompt
    set --local exit_status $status
    set --local duration $CMD_DURATION

    set -gx BRANCH (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

	echo -n (set_color brblack)"["(date "+%H:%M")"] "
    set_color blue; prompt_pwd2
	printf (set_color brblack)'%s ' (__fish_git_prompt | sed 's/^ (/ /' | sed 's/)$//')

    # Show the time that the previous command took
    if [ $duration -gt '3000' ]
        printf (set_color yellow)'%s ' (format_duration $duration false)
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

function fish_greeting; end
