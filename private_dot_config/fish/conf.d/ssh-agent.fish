# set -x SSH_AUTH_SOCK /Users/danielpendolino/.ssh/agent
bass (ssh-agent) &> /dev/null
grep -slR "PRIVATE" ~/.ssh | xargs ssh-add &> /dev/null
