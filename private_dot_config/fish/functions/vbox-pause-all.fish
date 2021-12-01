# Defined in - @ line 1
function vbox-pause-all --wraps=vboxmanage\ list\ runningvms\ \|\ sed\ -r\ \"s/.\*\\\{\(.\*\)\\\}/\\1/\"\ \|\ xargs\ -L1\ -I\ \{\}\ VBoxManage\ controlvm\ \{\}\ savestate --description alias\ vbox-pause-all=vboxmanage\ list\ runningvms\ \|\ sed\ -r\ \"s/.\*\\\{\(.\*\)\\\}/\\1/\"\ \|\ xargs\ -L1\ -I\ \{\}\ VBoxManage\ controlvm\ \{\}\ savestate
  vboxmanage list runningvms | sed -r "s/.*\{(.*)\}/\1/" | xargs -L1 -I {} VBoxManage controlvm {} savestate $argv;
end
