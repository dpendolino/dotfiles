#!/bin/bash
if [ -d ~/.config/nvim ] && [ -d ~/.config/nvchad ]; then
	if [ ! -d ~/.config/nvim/lua/custom ]; then
		ln -s ~/.config/nvchad/lua/custom ~/.config/nvim/lua/custom
	fi
fi

nvim --headless +'hi NormalFloat guibg=#1e222a' +PackerCompile +qa
nvim --headless +'hi NormalFloat guibg=#1e222a' +PackerSync +qa
nvim --headless +'hi NormalFloat guibg=#1e222a' +PackerInstall +qa
