check () {
if [ $1 -eq 0 ]; then echo -e "[  Ok  ]" ; else echo -e "[ Fail ]" ; exit 1 ; fi
}

printf "%-80s" "REGOLITH I3 config"
yes | cp /etc/regolith/i3/config ../configs/i3 
check $?

printf "%-80s" "Configuring zshrc config"
yes | cp ~/.zshrc ../configs/zshrc 
check $?

printf "%-80s" "Configuring aliasrc"
yes | cp ~/.config/aliasrc ../configs 
check $?

printf "%-80s" "Configuring nvim"
yes | cp ~/.config/nvim/init.vim ../configs/init.vim  
check  $?