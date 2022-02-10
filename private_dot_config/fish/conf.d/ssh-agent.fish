# set -x SSH_AUTH_SOCK /Users/danielpendolino/.ssh/agent
pgrep ssh-agent || bass (ssh-agent) &> /dev/null
grep -slR "PRIVATE" ~/.ssh | xargs ssh-add &> /dev/null
