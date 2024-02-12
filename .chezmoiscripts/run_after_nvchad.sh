#!/bin/bash
if [ -d ~/.config/nvim ] && [ -d ~/.config/nvchad ]; then
	if [ ! -d ~/.config/nvim/lua/custom ]; then
		ln -s ~/.config/nvchad/lua/custom ~/.config/nvim/lua/custom
	fi
fi

ln -s ~/.config/nvchad/lua/custom ~/.config/nvim/lua/custom
sed -i "s/load_on_startup = true,/load_on_startup = false,/g" ~/.config/nvchad/lua/custom/chadrc.lua
nvim --headless +qa
nvim --headless "+Lazy! sync" +qa
sed -i "s/load_on_startup = false,/load_on_startup = true,/g" ~/.config/nvchad/lua/custom/chadrc.lua
