# If running from tty1 start sway
set TTY1 (tty)
if test -z "$DISPLAY"; and test $TTY1 = "/dev/tty1"
  set -x XDG_CURRENT_DESKTOP sway
  exec sway -d 2> /tmp/sway-debug.log
  # exec ck-launch-session dbus-launch --sh-syntax --exit-with-session sway
end
