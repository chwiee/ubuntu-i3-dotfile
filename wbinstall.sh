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

# Custom Ubuntu with i3
printf "%-80s" "Apt repository regolith"
sudo add-apt-repository ppa:regolith-linux/release
check $?

printf "%-80s" "Install regolith desktop"
sudo apt install regolith-desktop
check $?

printf "%-80s" "Apt repository regolith i3 bar"
sudo apt install i3xrocks-net-traffic i3xrocks-cpu-usage i3xrocks-time
check $?

printf "%-80s" "Apt repository regolith baterry"
sudo apt install i3xrocks-battery
check $?

# General Settings
if [ ! -d /projects ]; then
  printf "%-80s" "Creating /projects folder "
  mkdir /projects
  check $?
fi

if [ ! -d /projects/scripts ]; then
  printf "%-80s" "Copy ./script folder to /projects"
  cp ./scripts /projects/scripts
fi

if [ ! -d ~/.config/nvim ]; then
  printf "%-80s" "Setting nvim config"
  mkdir ~/.config/nvim &>/dev/null
  check  $?
fi

printf "%-80s" "Configuring REGOLITH I3 config"
yes | cp ./configs/i3 /etc/regolith/i3/config &>/dev/null
ln -s /etc/regolith/i3/config ~/.config/i3
check $?

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
  firefox 
  zsh 
  cmatrix 
  xclip 
  unzip
  tree
)

for BR in ${HUE[@]}; do
  wbinstall $BR 
done

# Need to Devs
declare -a DEVS=(
  python-software-properties 
  fonts-firacode 
  nodejs 
  npm 
  yarn 
  python-pip 
  python3 
  clang 
  gcc 
  make 
)

for DEV in ${DEVS[@]}; do
  wbinstall $DEV
done

# Need to DevOps
declare -a OPS=(
  git 
  docker 
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


printf "%-80s" "Installing Go Lang"
  cd /tmp
  wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz 
  tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
check $?

printf "%-80s" "Installing Helm 3"
  cd /tmp
  wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
  tar -xvzf helm-v3.2.4-linux-amd64.tar.gz
  chmod +x linux-amd64/helm
  sudo cp linux-amd64/helm /usr/local/bin/helm3
  sudo ln -sfn /usr/local/bin/helm3 /usr/local/bin/helm
check $?

printf "%-80s" "Installing helm-docs"
  cd /tmp
  git clone https://github.com/norwoodj/helm-docs
  cd helm-docs/cmd/helm-docs
  go build
  mv helm-docs /usr/local/bin/
  chmod +rx /usr/local/bin/helm-docs
check $?

printf "%-80s" "Installing Kubernetes - kubectl"
  cd /tmp &>/dev/null
  curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" &>/dev/null
  chmod +x ./kubectl &>/dev/null
  sudo mv ./kubectl /usr/local/bin/kubectl &>/dev/null
check $?

printf "%-80s" "Installing eksctl"
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp &>/dev/null
  mv /tmp/eksctl /usr/local/bin &>/dev/null
check $?

printf "%-80s" "Installing Kubectx"
  cd /tmp
  wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx
  chmod +x kubectx
  mv kubectx /usr/local/bin
check $?

printf "%-80s" "Installing Kubens"
  cd /tmp
  wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens 
  chmod +x  kubens
  sudo mv kubens  /usr/local/bin
check $?

printf "%-80s" "Export PATH"
  export PATH=$PATH:/usr/local/go/bin
  export PATH=$PATH:/usr/local/bin/helm
  export PATH=$PATH:/usr/local/bin/helm3
  export PATH=$PATH:/usr/local/bin/helm-docs
  export PATH=$PATH:/usr/local/bin/kubectl
  export PATH=$PATH:/usr/local/bin/eksctl
  export PATH=$PATH:/usr/local/bin/kubectx
  export PATH=$PATH:/usr/local/bin/kubens
check $?