if [ -n "$TMUX" ]
    set -x NVIM_LISTEN_ADDRESS (tmux show-environment | grep NVIM | grep -o '=.*' | cut  -c2-)
end
