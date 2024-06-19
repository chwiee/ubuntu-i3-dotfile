#!/bin/bash

# Atualizar repositórios e sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências
sudo apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
  libxcb-util0-dev xcb libxcb-icccm4-dev libyajl-dev libev-dev \
  libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev \
  libxkbcommon-x11-dev libxcb-randr0-dev libxcb-xrm-dev libxcb-shape0-dev \
  git build-essential cmake meson ninja-build

# Instalar i3-gaps
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
mkdir -p build && cd build
meson ..
ninja
sudo ninja install
cd ../..
rm -rf i3-gaps

# Instalar feh para gerenciar papel de parede
sudo apt install -y feh

# Instalar rofi para menu
sudo apt install -y rofi

# Instalar i3lock-fancy para tela de bloqueio
sudo apt install -y imagemagick scrot
git clone https://github.com/meskarune/i3lock-fancy.git
sudo mv i3lock-fancy /usr/local/bin/i3lock-fancy
sudo chmod +x /usr/local/bin/i3lock-fancy/lock

# Instalar polybar
sudo apt install -y cmake cmake-data libcairo2-dev libxcb1-dev \
  libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen \
  xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev \
  libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev \
  libnl-genl-3-dev
git clone --recursive https://github.com/polybar/polybar
cd polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install
cd ../..
rm -rf polybar

# Instalar dunst para notificações
sudo apt install -y dunst
mkdir -p ~/.config/dunst
cat <<EOL > ~/.config/dunst/dunstrc
[global]
timeout = 10

[frame]
width = 2

[notification]
padding = 8
transparency = 10
alignment = left

[urgency_low]
background = "#222222"
foreground = "#888888"

[urgency_normal]
background = "#285577"
foreground = "#ffffff"

[urgency_critical]
background = "#900000"
foreground = "#ffffff"
EOL

# Configurar i3
mkdir -p ~/.config/i3
cat <<EOL > ~/.config/i3/config
# Configurações básicas do i3
set \$mod Mod4
font pango:monospace 10

# Configurações básicas de bordas e gaps
for_window [class="^.*"] border pixel 2
gaps inner 15
gaps outer 15

# Variáveis
set \$term --no-startup-id alacritty
set \$shutdown sudo -A shutdown -h now
set \$reboot sudo -A reboot
set \$netrefresh --no-startup-id sudo -A systemctl restart NetworkManager
set \$hibernate sudo -A systemctl suspend

# Comandos de inicialização
exec --no-startup-id feh --bg-fill ~/Pictures/1613400891967.jpg
exec_always --no-startup-id xrdb -load ~/.Xresources
exec --no-startup-id sh ~/.fehbg
exec --no-startup-id /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec --no-startup-id nitrogen --restore; sleep 1; compton -b
exec --no-startup-id nm-applet
exec --no-startup-id blueman-applet
exec_always --no-startup-id ff-theme-util
exec_always --no-startup-id fix_xcursor

# Foco do mouse
focus_follows_mouse no

# Atalhos básicos
bindsym \$mod+Return exec \$term
bindsym \$mod+Shift+q kill
bindsym \$mod+d exec --no-startup-id rofi -show run
bindsym \$mod+w exec --no-startup-id firefox
bindsym \$mod+Shift+w exec --no-startup-id chromium
bindsym \$mod+Shift+Escape exec --no-startup-id /usr/local/bin/i3lock-fancy/lock
bindsym \$mod+Shift+question exec --no-startup-id ~/.config/i3/helpmenu.sh

# Configurações de Wi-Fi e Bluetooth
bindsym \$mod+Shift+w exec --no-startup-id nm-connection-editor
bindsym \$mod+Shift+b exec --no-startup-id blueman-manager

# Gerenciamento de tela
bindsym \$mod+Shift+d exec --no-startup-id arandr

# Movimento e redimensionamento
bindsym \$mod+h focus left
bindsym \$mod+j focus down
bindsym \$mod+k focus up
bindsym \$mod+l focus right
bindsym \$mod+Shift+h move left 30
bindsym \$mod+Shift+j move down 30
bindsym \$mod+Shift+k move up 30
bindsym \$mod+Shift+l move right 30

# Modos de layout
bindsym \$mod+e layout toggle split
bindsym \$mod+f fullscreen toggle
bindsym \$mod+y layout stacking
bindsym \$mod+t layout tabbed

# Gaps
bindsym \$mod+s gaps inner current plus 5
bindsym \$mod+Shift+s gaps inner current minus 5
bindsym \$mod+Shift+g mode "gaps"
mode "gaps" {
        bindsym o mode "outer"
        bindsym i mode "inner"
        bindsym Return mode "default"
        bindsym Escape mode "default"
}
mode "outer" {
        bindsym plus  gaps outer current plus 5
        bindsym minus gaps outer current minus 5
        bindsym 0     gaps outer current set 0
        bindsym Shift+plus  gaps outer all plus 5
        bindsym Shift+minus gaps outer all minus 5
        bindsym Shift+0     gaps outer all set 0
        bindsym Return mode "default"
        bindsym Escape mode "default"
}
mode "inner" {
        bindsym plus  gaps inner current plus 5
        bindsym minus gaps inner current minus 5
        bindsym 0     gaps inner current set 0
        bindsym Shift+plus  gaps inner all plus 5
        bindsym Shift+minus gaps inner all minus 5
        bindsym Shift+0     gaps inner all set 0
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

# Workspaces
set \$ws1 1
set \$ws2 2
set \$ws3 3
set \$ws4 4
set \$ws5 5
set \$ws6 6
set \$ws7 7
set \$ws8 8

# Mudança e movimentação de contêineres entre workspaces
bindsym \$mod+1 workspace \$ws1
bindsym \$mod+2 workspace \$ws2
bindsym \$mod+3 workspace \$ws3
bindsym \$mod+4 workspace \$ws4
bindsym \$mod+5 workspace \$ws5
bindsym \$mod+6 workspace \$ws6
bindsym \$mod+7 workspace \$ws7
bindsym \$mod+8 workspace \$ws8
bindsym \$mod+Ctrl+1 move container to workspace \$ws1
bindsym \$mod+Ctrl+2 move container to workspace \$ws2
bindsym \$mod+Ctrl+3 move container to workspace \$ws3
bindsym \$mod+Ctrl+4 move container to workspace \$ws4
bindsym \$mod+Ctrl+5 move container to workspace \$ws5
bindsym \$mod+Ctrl+6 move container to workspace \$ws6
bindsym \$mod+Ctrl+7 move container to workspace \$ws7
bindsym \$mod+Ctrl+8 move container to workspace \$ws8
bindsym \$mod+Shift+1 move container to workspace \$ws1; workspace \$ws1
bindsym \$mod+Shift+2 move container to workspace \$ws2; workspace \$ws2
bindsym \$mod+Shift+3 move container to workspace \$ws3; workspace \$ws3
bindsym \$mod+Shift+4 move container to workspace \$ws4; workspace \$ws4
bindsym \$mod+Shift+5 move container to workspace \$ws5; workspace \$ws5
bindsym \$mod+Shift+6 move container to workspace \$ws6; workspace \$ws6
bindsym \$mod+Shift+7 move container to workspace \$ws7; workspace \$ws7
bindsym \$mod+Shift+8 move container to workspace \$ws8; workspace \$ws8

# Configuração da borda azul para a janela focada
client.focused #4c7899 #285577 #4c7899 #285577

# Configurações do Polybar
exec_always --no-startup-id polybar example

# Configuração do terminal (Alacritty)
mkdir -p ~/.config/alacritty
cat <<EOL > ~/.config/alacritty/alacritty.yml
window:
  opacity: 0.75

colors:
  primary:
    background: '0x000000'
EOL

# Script de ajuda
mkdir -p ~/.config/i3
cat <<EOL > ~/.config/i3/helpmenu.sh
#!/bin/bash
help_content="Super + Enter: Abrir terminal\n
Super + D: Abrir dmenu/rofi\n
Super + W: Abrir Firefox\n
Super + Shift + Q: Fechar janela\n
Super + H: Mover janela para esquerda\n
Super + J: Mover janela para baixo\n
Super + K: Mover janela para cima\n
Super + L: Mover janela para direita\n
Super + Shift + Esc: Menu de energia\n
Super + Shift + ?: Menu de ajuda\n
Super + Shift + D: Abrir gerenciador de tela (arandr)\n
Super + Shift + W: Configurações de Wi-Fi\n
Super + Shift + B: Configurações de Bluetooth\n
Super + Shift + R: Reiniciar i3\n
Super + F: Modo full-screen\n
Super + V: Modo split vertical\n
Super + H: Modo split horizontal"
echo -e \$help_content | rofi -dmenu -i -p "Help Menu" -no-config
EOL
chmod +x ~/.config/i3/helpmenu.sh

echo "Instalação e configuração do i3-gaps concluída. Reinicie o sistema para aplicar as mudanças."
