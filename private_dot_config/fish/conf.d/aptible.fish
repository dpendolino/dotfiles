set -x APTIBLE_OUTPUT_FORMAT json

function aptible-login
  aptible login --email (op get item Aptible --fields email) --password (op get item Aptible --fields password) --otp-token (op get totp Aptible)
end
