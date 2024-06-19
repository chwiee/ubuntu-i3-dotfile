#!/bin/bash

check () {
if [ $1 -eq 0 ]; then echo -e "[  Ok  ]" ; else echo -e "[ Fail ]" ; exit 1 ; fi
}

wbinstall (){
  printf "%-80s" "Installing $1"
  sudo apt-get install -y $1 &>/dev/null
  check $?
}

echo '
# -- ----------
# -- Wallace Bruno Gentil
# -- Ubuntu dotfile
# -- ----------
'

if [ "$EUID" -ne 0 ]
  then echo "Please run as root 'sudo'"
  exit
fi


printf "%-80s" "Apt repository regolith i3 bar"
sudo apt install i3xrocks-net-traffic i3xrocks-cpu-usage i3xrocks-time
check $?

printf "%-80s" "Apt repository regolith baterry"
sudo apt install i3xrocks-battery
check $?

# General Settings
if [ ! -d ~/.config/nvim ]; then
  printf "%-80s" "Setting nvim config"
  mkdir ~/.config/nvim &>/dev/null
  check  $?
fi
printf "%-80s" "Configuring zshrc config"
yes | cp ./configs/zshrc ~/.zshrc &>/dev/null
check $?

printf "%-80s" "Configuring aliasrc"
yes | cp ./configs/aliasrc ~/.config &>/dev/null
check $?

printf "%-80s" "Configuring nvim"
yes | cp ./configs/init.vim ~/.config/nvim &>/dev/null
check  $?

printf "%-80s" "Installing neovim support"
pip install --user pynvim &>/dev/null
check  $?

printf "%-80s" "Installing highligh syntax to ZSH"
git clone https://github.com/zdharma/fast-syntax-highlighting ~/.config/zsh_configs/plugins/fast-syntax-highlighting.plugin.zsh &>/dev/null
check  $?

printf "%-80s" "Installing Power level 10 K to terminal"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k &>/dev/null
check  $?

# Need to Hue
declare -a HUE=(
  software-properties-common 
  apt-transport-https
  libcanberra-gtk-module 
  gnupg2
  nitrogen 
  ranger 
  caca-utils 
  neovim 
  highlight 
  atool 
  w3m 
  poppler-utils 
  mediainfo 
  arandr 
  zsh 
  cmatrix 
  xclip 
  unzip
  tree
)

for BR in ${HUE[@]}; do
  wbinstall $BR 
done

declare -a OPS=(
  git 
  screen 
  curl 
  wget 
  gparted 
  htop 
  awscli
)

for OP in ${OPS[@]}; do
  wbinstall $OP
done

