#!/bin/bash

# colors
red='\e[1;91m'
green='\e[1;92m'
reset='\e[0m'

helpFunction() {
  echo ""
  echo "Usage: $0 -u victor -i gnome"
  echo -e "\t-u set user name"
  echo -e "\t-b set the GUI to be installed [gnome, kde, xfce, i3wm]"
  exit 1 # Exit script after printing help
}

while getopts "u:i:" opt; do
  case "$opt" in
  u) username="$OPTARG" ;;
  i) gui="$OPTARG" ;;
  ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

install() {
  clear

  echo -e "${green}Selected Username: $username ${reset}"
  echo -e "${green}Selected Interface: $gui ${reset}\n\n"

  # configure pacman
  sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/locale.gen
  pacman -Syyu
  echo -e "${green}PACMAN configurated!${reset}"
  echo -e "${green}\nSTARTING INSTALATION...\n${reset}"

  # configure timezone and locale
  ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime
  hwclock --systohc
  sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
  sed -i 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
  locale-gen
  echo KEYMAP=br-abnt2 >>/etc/vconsole.conf

  # set hostname
  echo arch >>/etc/hostname

  # set root and user password
  echo -e "${green}\nSet root password${reset}"
  passwd
  useradd -m -g users -G wheel,storage,power -s /bin/bash victor
  echo -e "${green}\nSet user password${reset}"
  passwd victor
  sed -i 's/# %wheel ALL(ALL:ALL) ALL/ %wheel ALL(ALL:ALL) ALL/g' /etc/sudoers

  # install essential programs
  pacman -S --noconfirm \
    dosfstools \
    os-prober \
    mtools \
    network-manager-applet \
    networkmanager \
    wpa_supplicant \
    wireless_tools \
    dialog \
    archlinux-keyring

  # grub configuration
  pacman -S --noconfirm grub efibootmgr
  grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
  grub-mkconfig -o /boot/grub/grub.cfg

  # install utils
  echo -e "${green}\nSTARTING GUI INSTALATION PROCCESS...\n${reset}"
  PROGRAMS_TO_INSTALL=(
    xorg
    mesa
    xf86-video-intel
    nvidia
    nvidia-settings
    firefox
    git
    go
    htop
    neofetch
    alacritty
    i3
    dmenu
    rofi
    feh
    flameshot
    flatpak
    pavucontrol
    pulseaudio
    alsa-utils
  )

  for program_name in ${PROGRAMS_TO_INSTALL[@]}; do
    pacman -S --noconfirm "$program_name"
    echo -e "${green} $program_name installed! ${reset}"
  done

  installGNOME() {
    pacman -S --noconfirm gdm gnome gnome-terminal gnome-tweaks
    systemctl enable gdm
  }

  installKDE() {
    pacman -S --noconfirm sddm plasma konsole
    systemctl enable sddm
  }

  installXFCE() {
    pacman -S --noconfirm sddm xfce4 xfce4-goodies xfce4-terminal
    systemctl enable sddm
  }

  installI3WM() {
    pacman -S --noconfirm i3-gaps dmenu i3status i3blocks thunar
    cp /etc/X11/xinit/xinitrc ~/.xinitrc
    echo "exec i3" >>~/.xinitrc
  }

  # install GUI
  if [ "$gui" == "gnome" ]; then
    echo -e "\n${green}installing gnome${reset}"
    installGNOME
  elif [ "$gui" == "kde" ]; then
    echo -e "\n${green}installing kde${reset}"
    installKDE
  elif [ "$gui" == "xfce" ]; then
    echo -e "\n${green}installing xfce${reset}"
    installXFCE
  elif [ "$gui" == "i3" ]; then
    echo -e "\n${green}installing i3${reset}"
    installI3WM
  else
    echo -e "\n${red}gui not recognized!${reset}"
    helpFunction
    exit 1
  fi

  # enable network
  systemctl enable NetworkManager

  echo -e "${green}\n\nSCRIPT FINISHED WITH SUCCESS...\n${reset}"
}

# Script entry
if [ -z "$username" ] || [ -z "$gui" ]; then
  echo "Some or all of the parameters are empty"
  helpFunction
else
  install
fi
