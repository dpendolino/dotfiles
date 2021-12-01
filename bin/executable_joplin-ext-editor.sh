#!/bin/bash
if [ $# -eq 1 ]; then
	/usr/bin/termite -e "nvim $1"
else
	/usr/bin/termite -e "$2 $3"
fi
