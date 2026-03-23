# Stop yanking of deleted words
set FISH_CLIPBOARD_CMD cat

# Env vars
set -x SHELL (which fish)
set -x PATH $HOME/.local/bin $PATH
set -x LD_LIBRARY_PATH $HOME/.local/lib $LD_LIBRARY_PATH
set -x PROJVC $HOME/ProjVC
set -x PROJMPI $HOME/ProjMPI
set -x GCC_COLORS auto
set -x NINJA_STATUS "[%r/%u/%f/%t] "

# Aliases
alias config='git --git-dir=$HOME/.config.git/ --work-tree=$HOME'

function mc
    set tmpfile /tmp/mcpwd-(random)
    command mc -P $tmpfile
    cd (cat $tmpfile)
    rm $tmpfile
end

# Gem path
if which gem ruby >/dev/null
    set -x PATH (ruby -e 'puts Gem.user_dir')/bin $PATH
end

if which gem2.0 ruby2.0 >/dev/null
    set -x PATH (ruby2.0 -e 'puts Gem.user_dir')/bin $PATH
end

# ccache path
if which ccache >/dev/null
    set -x PATH /usr/lib/ccache $PATH
end

if which zoxide >/dev/null
    zoxide init fish | source
end

if which zellij >/dev/null
    zellij setup --generate-completion fish | source
end

# Go path
set -x GOPATH $HOME/.local/go
set -x PATH $GOPATH/bin $PATH

# Rust path
set -x PATH $HOME/.cargo/bin $PATH

# OPAM configuration
. $HOME/.opam/opam-init/init.fish- >/dev/null 2>/dev/null or true

# fuck
if which thefuck >/dev/null
    eval (thefuck --alias | tr '\n' ';')
end

# yazi PWD
if which yazi >/dev/null
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end
end

# bindings
bind \ew backward-kill-line # alt+w delete to start of line

# Load private configuration
. $HOME/.config/fish/config_private.fish

# opencode
fish_add_path /home/janickm/.opencode/bin

# bun
set -x BUN_INSTALL "$HOME/.bun"
set -x PATH $BUN_INSTALL/bin $PATH
