# Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

function ecr-login
  hash docker &>/dev/null && aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 205034600246.dkr.ecr.us-east-1.amazonaws.com
  hash podman &>/dev/null && aws ecr get-login-password --region us-east-1 | podman login --username AWS --password-stdin 205034600246.dkr.ecr.us-east-1.amazonaws.com
end
