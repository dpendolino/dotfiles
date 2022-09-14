#!/usr/bin/env bash
set -o pipefail

echo "killing gui"
pkill -f AnyConnect

echo "getting password"
pass=$(lpass show --password onelogin.com)

echo "hit the yubikey you dolt"
read -r otp

/opt/cisco/anyconnect/bin/vpn disconnect

nohup open -a "Cisco AnyConnect Secure Mobility Client" &>/dev/null &

/opt/cisco/anyconnect/bin/vpn -s < <(
	echo "connect vpn.ibotta.com"
	echo "daniel.pendolino@ibotta.com"
	echo "$pass"
	echo "$otp"
)
