source ~/.config/nvim/base16/shell/scripts/base16-circus.sh

ZDOTDIR=~/.zsh/zim

zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:git:dirty color 242

setopt HIST_IGNORE_ALL_DUPS

# Evil mode because I don't want my command-line to change modes while I'm doing shit
bindkey -e

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Module configuration

# zsh-autosuggestions
# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# zsh-syntax-highlighting

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# Initialize Zim Modules
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# Post-init module configuration
# zsh-history-substring-search
zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' '^k' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' '^j' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
unset key

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Personal Config

# mkcd <directory>
mkcd () {
    mkdir $1 && cd $1
}

# Extact a file or files depending on their file suffix
# extract <files...>
extract () {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
        return 1
    else
        for n in $@; do
            if [ -f "$n" ] ; then
                case "${n%,}" in
                    *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                        tar xvf "$n"       
                    ;;
                    *.gz)  gunzip ./"$n" ;;
                    *.zip) unzip ./"$n" ;;
                    *)
                        echo "extract: '$n' - unknown archive method"
                        return 1
                    ;;
                esac
            else
                echo "'$n' - file does not exist"
                return 1
            fi
        done
    fi
}

# Sync local files with server files
fsa () {
    # Requires server and client to be setup with unison (https://github.com/bcpierce00/unison)
    # `server` hostname is from ssh config
    unison -auto -batch ~/sync ssh://server/sync
}

# Sync local files with server files
# See `fsa` above
fs () {
    unison -auto ~/sync ssh://server/sync
}

# b/c I'm dumb and will forget
my-ip () {
    printf "Use \`ips\`\n"
    return 1
}

# View information about my IPs
ips () {
    printf "Internal IP: %s\n" $(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
    printf "External IP: %s\n" $(curl -s http://ifconfig.io)
}

# Run a task in the bg
# bg <command>
bg () {
    setsid $@ &> /dev/null &
}

# Clone one of my personal repos
# gcme <repo>
gcme () {
    git clone git@github.com:funnyboy-roks/$1.git $2
}

# Clone a git repo and cd into the dir that it makes
gcd () {
    git clone $1 $2
    if ! [ -z $2 ] ; then # if $2 is specified, that's the dir in which the repo was cloned
        cd $2
    else
        cd "${"$(basename $1)"%.*}" # otherwise, get it from the name
    fi
}

# Takes an optional time and then copies the discord format
# to the keyboard and prints to stdout
# 
# If time is not specified, then uses the current time
dt () {
    local args
    local flag
    if [[ "$1" =~ ^(-[dDtTfFR])$ ]]; then
        flag="${1/-/:}"
        args="${@:2}"
    fi
    : ${args:=${*-now}}
    out=$(date +"t:%s$flag" -d "$args")
    echo "<$out>"
    printf "<$out>" | xclip -i -selection clipboard
    notify-send 'Copied to clipboard' "&lt;$out&gt;"
}

# Get the time elapsed since a program started
# Searches all running processes for the name provided in $1
elapsed () {
    ps -eo pid,cmd,stime,etime | \grep -iE "$1|PID" | \grep -vE '(grep|ps)'
}

# Swap two files using a random file in /tmp/
swap () {
    if [[ $# -ne 2 ]]; then
        echo "Usage: swap <file1> <file2>" >&2
        return 1
    fi

    local tmp_path="/tmp/SWAP_$(cat /dev/urandom | base64 | tr -dc '0-9a-zA-Z' | head -c15)"
    mv $1 $tmp_path
    mv $2 $1
    mv $tmp_path $2
}

setopt clobber # Allow things like echo 'a' > b.txt if b.txt exists.
setopt globdots # Tab complete "hidden" files (hate that term)

tabs -4 # set tabwidth = 4

JAVA_HOME="/usr/lib/jvm/default"
PATH="$PATH:$HOME/.cargo/bin:$HOME/scripts:$HOME/.local/bin"

# Start tmux if we're in guake
# arguably, we could do `-ne 'tmux: server'`, but I think that may be too generic
[ "$(pstree -sA $$ | awk -F "---" '{ print $2 }')" = 'guake' ] && tmux new

eval $(thefuck --alias)
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Init fzf (^T)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

unalias l

export EDITOR=nvim
export MANPAGER='nvim +Man!'
export PAGER='nvim -R'

alias ll="eza -lhaF --icons --git"
alias cd="cd -P" # I like cd to resolve links
alias cp="cp -v" # Give me verbosity
alias rm="rm -v" # Give me verbosity
alias mv="mv -v" # Give me verbosity
alias mkdir="mkdir -pv" # Create parent folders and give me verbosity
alias python="python3"
alias tree="eza -ThaF --icons --git -I 'target|node_modules|venv|.git'"
alias :q="exit" # I can't help the vi
alias serve="basic-http-server" # https://github.com/brson/basic-http-server

# Most servers don't have alacritty term info
# This is less useful since I'm using tmux now
[[ $TERM = "alacritty" ]] && alias ssh="TERM=xterm-256color ssh"

export FPATH="~/dev/completions/eza/completions/zsh:$FPATH"

# Git Aliases
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gl='git log'
alias gp='git pull'
alias gpsh='git push'
alias gss='git status -s'
alias feh='feh -B "#222" --force-aliasing --keep-zoom-vp -z'
alias find='noglob find'

eval "$(atuin init zsh --disable-up-arrow)"
