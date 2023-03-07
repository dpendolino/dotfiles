#!/bin/bash -eu
set -o pipefail

sudo nmap -sP 10.1.1.0/24 | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'
