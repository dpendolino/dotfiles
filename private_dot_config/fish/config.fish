bass source /etc/profile

set -x PATH $PATH $HOME/.cargo/bin/

starship init fish | source

# Set SSH to use Gnome keyring
set -gx SSH_AUTH_SOCK (gnome-keyring-daemon --start | grep "^SSH_AUTH_SOCK" | awk -F "=" '{print $2}')

thefuck --alias | source
# /home/dpendolino/.local/bin/thefuck --alias | source

function fish_greeting
  archey3
end

# set the workspace path
set -x GOPATH /home/dpendolino/go

# add the go bin path to be able to execute our programs
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin

# add ~/bin to path
set -x PATH $PATH /home/dpendolino/bin
set -x PATH $PATH /home/dpendolino/.local/bin
set -x PATH $PATH /home/dpendolino/git/isomorphic-copy/bin

alias sshf="ssh (rg -i 'Host ' $HOME/.ssh/config | awk '{print $2}' | fzf)"

alias cat="bat"

# Global Packer cache
set -x PACKER_CACHE_DIR $HOME/packer_cache

set -x LANG en_US.UTF-8

# https://github.com/lastpass/lastpass-cli/issues/194
set -x LPASS_HOME $HOME/.lpass

# https://github.com/lastpass/lastpass-cli/issues/430
set -x LPASS_AGENT_TIMEOUT 10800

# npm bin path
set -x PATH $PATH /home/dpendolino/node_modules/.bin

# gem path
set -x GEM_HOME "(ruby -e 'puts Gem.user_dir')"
set -x PATH $PATH "$GEM_HOME/bin"
#set -x PATH $PATH vagrant /home/dpendolino/.gem/ruby/2.7.0/bin

# ripgrep config file
set -x RIPGREP_CONFIG_PATH $HOME/.ripgreprc

# https://gitlab.gnome.org/GNOME/gnome-keyring/-/issues/28
set -x XDG_RUNTIME_DIR /run/user/(id -u $USER)

# pick correct vulkan driver
if test $hostname = "prometheus"
  set -x VK_ICD_FILENAMES /usr/share/vulkan/icd.d/amd_icd64.json:/usr/share/vulkan/icd.d/amd_icd32.json
end

set -x EDITOR nvim
set -x VISUAL nvim
