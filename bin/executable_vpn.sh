#!/usr/bin/env bash
set -o pipefail

if [ -z "$BW_SESSION" ] || bw status | grep "locked" &>/dev/null; then
  BW_SESSION=$(bw unlock --raw | grep -o '.*==$')
fi

echo "killing gui"
pkill -f AnyConnect

echo "getting password"
pass=$(bw get password password onelogin.com --session $BW_SESSION)

echo "hit the yubikey you dolt"
read -r otp

/opt/cisco/anyconnect/bin/vpn disconnect

nohup open -a "Cisco AnyConnect Secure Mobility Client" &>/dev/null &

/opt/cisco/anyconnect/bin/vpn -s < <(
	echo "connect vpn.ibotta.com"
  echo "$(bw get username onelogin.com --session $BW_SESSION)"
	echo "$pass"
	echo "$otp"
)
