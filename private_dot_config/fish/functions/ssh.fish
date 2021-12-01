# https://sw.kovidgoyal.net/kitty/faq.html?highlight=ssh
# push kitty terminfo whenever ssh is called
function ssh --description 'alias ssh=kitty +kitten ssh'
  kitty +kitten ssh $argv;
end
