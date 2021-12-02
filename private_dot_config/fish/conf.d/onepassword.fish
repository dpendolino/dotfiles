# Set up 1Password session for all shells
function op-signin
  set OP_SESSION_FILE ~/.onepassword-session
  if test -f "$OP_SESSION_FILE"
    source "$OP_SESSION_FILE"
    if test -n "$OP_SESSION_springhealth"
      eval (op signin springhealth --session $OP_SESSION_springhealth | tee ~/.onepassword-session)
    else
      eval (op signin springhealth | tee ~/.onepassword-session)
    end
  else
    eval (op signin springhealth | tee ~/.onepassword-session)
  end
  chmod 0600 $OP_SESSION_FILE
end
