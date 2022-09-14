function aws-accounts
  saml2aws login --password=$(lpass show --password onelogin.com) --username=$(lpass show --username onelogin.com)
  set -x CUSTOM_AWS_ROLE (sed -n 's/.*\[profile *\([^][]*\).*/\1/p' ~/.aws/config|fzf)
  if test "$CUSTOM_AWS_ROLE" = '\n'
    set -u CUSTOM_AWS_ROLE
  end
  saml2aws exec --exec-profile="$CUSTOM_AWS_ROLE" -- fish
end
