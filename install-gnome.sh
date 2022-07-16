# colors
red='\e[1;91m'
green='\e[1;92m'
reset='\e[0m'

# ==============================================================================

sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/locale.gen
pacman -Syyu
echo -e "${green}PACMAN configurated!${reset}"
echo -e "${green}\nSTARTING INSTALATION...\n${reset}"

ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime
hwclock --systohc
echo -e "${green}TIMEZONE configurated!${reset}"

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
locale-gen
echo -e "${green}LOCALE configurated!${reset}"

echo KEYMAP=br-abnt2 >>/etc/vconsole.conf

echo arch >>/etc/hostname
echo -e "${green}HOSTNAME configurated!${reset}"

echo -e "${green}Set root password${reset}"
passwd

useradd -m -g users -G wheel,storage,power -s /bin/bash victor

echo -e "${green}###\nSet user password###\n${reset}"
passwd victor

echo -e "${green}PASSWORDS configurated!${reset}"
echo -e "${green}\nSTARTING PRORGRAMS INSTALL...\n${reset}"

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

pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
echo -e "${green}GRUB configurated!${reset}"

systemctl enable NetworkManager

echo -e "${green}\nSTARTING GUI INSTALATION PROCESS...\n${reset}"
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
)

for program_name in ${PROGRAMS_TO_INSTALL[@]}; do
  pacman -S --noconfirm "$program_name"
  echo -e "${green} $nome_do_programa installed! ${reset}"
done

# install Gnome
pacman -S --noconfirm \
  gdm \
  gnome \
  gnome-terminal

systemctl enable gdm

echo -e "${green}\nSCRIPT FINISHED WITH SUCCESS...\n${reset}"
