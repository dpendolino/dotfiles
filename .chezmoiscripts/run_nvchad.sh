#!/bin/bash
if [ -d ~/.config/nvim ] && [ -d ~/.config/nvchad ]; then
	if [ ! -d ~/.config/nvim/lua/custom ]; then
		ln -s ~/.config/nvchad/lua/custom ~/.config/nvim/lua/custom
	fi
fi

nvim --headless +qa
nvim --headless "+Lazy! sync" +qa
